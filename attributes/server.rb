#
# Cookbook Name:: gluster
# Attributes:: server
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

# Server package and servicename
default['gluster']['server']['package'] = 'glusterfs-server'
default['gluster']['server']['servicename'] = value_for_platform_family(
  'debian' => 'glusterfs-server',
  'default' => 'glusterd'
)

# enable or disable server service
default['gluster']['server']['enable'] = true

# enable or disable server extending support
default['gluster']['server']['server_extend_enabled'] = true

# Package dependencies
default['gluster']['server']['dependencies'] = %w[xfsprogs lvm2]

# Default path to use for mounting bricks
default['gluster']['server']['brick_mount_path'] = '/gluster'
# Gluster volumes to create
default['gluster']['server']['volumes'] = {}
# Set by the cookbook once bricks are configured and ready to use
default['gluster']['server']['bricks'] = []

# List of disk managed by lvm
default['gluster']['server']['disks'] = []

# default brick directory name
default['gluster']['server']['brick_dir'] = 'brick'

# Retry delays for attempting peering
default['gluster']['server']['peer_retries'] = 0
default['gluster']['server']['peer_retry_delay'] = 10

# Retry delays for waiting for peer
default['gluster']['server']['peer_wait_retries'] = 10
default['gluster']['server']['peer_wait_retry_delay'] = 10

# For extend recipe
default['gluster']['server']['bricks_waiting_to_join'] = ''

# For compile time loading of lvm gem
default['lvm']['di-ruby-lvm']['compile_time'] = true
default['lvm']['di-ruby-lvm-attrib']['compile_time'] = true

# In your role cookbook or similar, copy one of the following examples to create your cluster
# This example will create three gluster volumes over two nodes, with different volume types
# And with different sizes

# default['gluster']['server']['volumes'] = {
#  'gv0' => {
#    'peers' => ["gluster1","gluster2"],
#    'replica_count' => 2,
#    'volume_type' => 'replicated'
#    'size' => '10G'
#  },
#  'gv1' => {
#    'peers' => ["gluster1","gluster2"],
#    'replica_count' => 1,
#    'volume_type' => 'distributed',
#    'size' => '5G'
#  },
#  'gv2' => {
#    'peers' => ["gluster1","gluster2"],
#    'replica_count' => 2,
#    'volume_type' => 'striped',
#    'size' => '10G'
#  }
# }

# This example will create two gluster volumes over 4 nodes
# with different sizes

# default['gluster']['server']['volumes'] = {
#  'gv0' => {
#    'peers' => ["gluster1","gluster2", "gluster3", "gluster4"],
#    'replica_count' => 2,
#    'volume_type' => 'distributed-replicated'
#    'size' => '10G'
#  },
#  'gv1' => {
#    'peers' => ["gluster1","gluster2", "gluster3", "gluster4"],
#    'replica_count' => 2,
#    'volume_type' => 'distributed-replicated',
#    'size' => '20G'
#  }
# }
