#
# Cookbook Name:: gluster
# Recipe:: client_mount
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

# This recipe can be used to mount Gluster volumes using client atttributes.
#   It has been deprecated in favor of the gluster_mount LWRP and will be
#   removed in a future update.

node['gluster']['client']['volumes'].each do |volume_name, volume_values|
  if volume_values['server'].nil? || volume_values['mount_point'].nil?
    Chef::Log.warn("No config for volume #{volume_name}. Skipping...")
    next
  else
    # Define a backup server for this volume, if available
    mount_options = 'defaults,_netdev'
    unless volume_values['backup_server'].nil?
      mount_options += ',backupvolfile-server=' + volume_values['backup_server']
    end

    # Ensure the mount point exists
    directory volume_values['mount_point'] do
      recursive true
      action :create
    end

    # Mount the partition and add to /etc/fstab
    mount volume_values['mount_point'] do
      device "#{volume_values['server']}:/#{volume_name}"
      fstype 'glusterfs'
      options mount_options
      pass 0
      action [:mount, :enable]
    end
  end
end
