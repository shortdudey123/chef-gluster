#
# Cookbook Name:: gluster
# Recipe:: server_setup
#
# Copyright 2015, Grant Ridder
# Copyright 2015, Biola University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Loop through each configured partition
if node['gluster']['server'].attribute?('disks')
  node['gluster']['server']['disks'].each do |d|
    # If a partition doesn't exist, create it
    if `fdisk -l 2> /dev/null | grep '/dev/#{d}1'`.empty?
      # Pass commands to fdisk to create a new partition
      bash 'create partition' do
        code "(echo n; echo p; echo 1; echo; echo; echo w) | fdisk /dev/#{d}"
        action :run
      end

      # Format the new partition
      execute 'format partition' do
        command "mkfs.xfs -i size=512 /dev/#{d}1"
        action :run
      end
    end

    # Create a mount point
    directory "#{node['gluster']['server']['brick_mount_path']}/#{d}1" do
      recursive true
      action :create
    end

    # Mount the partition and add to /etc/fstab
    mount "#{node['gluster']['server']['brick_mount_path']}/#{d}1" do
      device "/dev/#{d}1"
      fstype 'xfs'
      action [:mount, :enable]
    end
  end
end

# Create and start volumes
bricks = []
node['gluster']['server']['volumes'].each do |volume_name, volume_values|
  # If the node is configured as a peer for the volume, create directories to use as bricks
  if volume_values['peers'].include?(node['fqdn']) || volume_values['peers'].include?(node['hostname'])
    # If using LVM
    if volume_values.attribute?('lvm_volumes') || node['gluster']['server'].attribute?('lvm_volumes')
      # Use either configured LVM volumes or default LVM volumes
      lvm_volumes = volume_values.attribute?('lvm_volumes') ? volume_values['lvm_volumes'] : node['gluster']['server']['lvm_volumes'].take(volume_values['replica_count'])
      lvm_volumes.each do |v|
        directory "#{node['gluster']['server']['brick_mount_path']}/#{v}/#{volume_name}" do
          recursive true
          action :create
        end
        bricks << "#{node['gluster']['server']['brick_mount_path']}/#{v}/#{volume_name}"
      end
    else
      # Use either configured disks or default disks
      disks = volume_values.attribute?('disks') ? volume_values['disks'] : node['gluster']['server']['disks'].take(volume_values['replica_count'])
      disks.each do |d|
        directory "#{node['gluster']['server']['brick_mount_path']}/#{d}1/#{volume_name}" do
          action :create
        end
        bricks << "#{node['gluster']['server']['brick_mount_path']}/#{d}1/#{volume_name}"
      end
    end
    # Save the array of bricks to the node's attributes
    node.set['gluster']['server']['bricks'] = bricks
  end

  # Only continue if the node is the first peer in the array
  if volume_values['peers'].first == node['fqdn'] || volume_values['peers'].first == node['hostname']
    # Configure the trusted pool if needed
    volume_values['peers'].each do |peer|
      next if peer == node['fqdn'] || peer == node['hostname']
      execute "gluster peer probe #{peer}" do
        action :run
        not_if "egrep '^hostname.+=#{peer}$' /var/lib/glusterd/peers/*"
        retries node['gluster']['server']['peer_retries']
        retry_delay node['gluster']['server']['peer_retry_delay']
      end
    end

    # Create the volume if it doesn't exist
    unless File.exist?("/var/lib/glusterd/vols/#{volume_name}/info")
      # Create a hash of peers and their bricks
      volume_bricks = {}
      brick_count = 0
      peers = volume_values.attribute?('peer_names') ? volume_values['peer_names'] : volume_values['peers']
      peers.each do |peer|
        if peer == node['hostname'] || node['fqdn']
          chef_node = node
        else
          chef_node = Chef::Node.find_or_create(peer)
        end
        chef_fqdn = chef_node['fqdn'] || chef_node['hostname']
        if chef_node['gluster']['server'].attribute?('bricks')
          peer_bricks = chef_node['gluster']['server']['bricks'].select { |brick| brick.include? volume_name }
          volume_bricks[chef_fqdn] = peer_bricks
          brick_count += (peer_bricks.count || 0)
        end rescue NoMethodError
      end

      # Create option string
      options = ''
      case volume_values['volume_type']
      when 'replicated'
        # Ensure the trusted pool has the correct number of bricks available
        if brick_count < volume_values['replica_count']
          Chef::Log.warn("Correct number of bricks not available: #{brick_count} available, #{volume_values['replica_count']} required for volume #{volume_name}. Skipping...")
          next
        else
          options = "replica #{volume_values['replica_count']}"
          volume_bricks.each do |peer, vbricks|
            options << " #{peer}:#{vbricks.first}"
          end
        end
      when 'distributed-replicated'
        # Ensure the trusted pool has the correct number of bricks available
        required_bricks = (volume_values['replica_count'] * volume_values['peers'].count)
        if brick_count != required_bricks
          Chef::Log.warn("Correct number of bricks not available: #{brick_count} available, #{required_bricks} required for volume #{volume_name}. Skipping...")
          next
        else
          options = "replica #{volume_values['replica_count']}"
          (1..volume_values['replica_count']).each do |i|
            volume_bricks.each do |peer, vbricks|
              options << " #{peer}:#{vbricks[i - 1]}"
            end
          end
        end
      end

      execute "gluster volume create #{volume_name} #{options}" do
        action :run
      end
    end

    # Start the volume
    execute "gluster volume start #{volume_name}" do
      action :run
      not_if { `gluster volume info #{volume_name} | grep Status`.include? 'Started' }
    end

    # Restrict access to the volume if configured
    if volume_values['allowed_hosts']
      allowed_hosts = volume_values['allowed_hosts'].join(',')
      execute "gluster volume set #{volume_name} auth.allow #{allowed_hosts}" do
        action :run
        not_if "egrep '^auth.allow=#{allowed_hosts}$' /var/lib/glusterd/vols/#{volume_name}/info"
      end
    end

    # Configure volume quote if configured
    if volume_values['quota']
      # Enable quota
      execute "gluster volume quota #{volume_name} enable" do
        action :run
        not_if "egrep '^features.quota=on$' /var/lib/glusterd/vols/#{volume_name}/info"
      end

      # Configure quota for the root of the volume
      execute "gluster volume quota #{volume_name} limit-usage / #{volume_values['quota']}" do
        action :run
        not_if "egrep '^features.limit-usage=/:#{volume_values['quota']}$' /var/lib/glusterd/vols/#{volume_name}/info"
      end
    end
  end
end
