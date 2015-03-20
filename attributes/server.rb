#
# Cookbook Name:: gluster
# Attributes:: server
#
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

# Server package
case node['platform']
when 'ubuntu'
  default['gluster']['server']['package'] = 'glusterfs-server'
when 'redhat', 'centos'
  default['gluster']['server']['package'] = 'glusterfs-server'
end

# Package dependencies
case node['platform']
when 'ubuntu'
  default['gluster']['server']['dependencies'] = ['xfsprogs']
when 'redhat', 'centos'
  default['gluster']['server']['dependencies'] = ['xfsprogs']
end

# Default path to use for mounting bricks
default['gluster']['server']['brick_mount_path'] = '/gluster'
# Partitions to create and format
default['gluster']['server']['partitions'] = []
# Gluster volumes to create
default['gluster']['server']['volumes'] = {}
# Set by the cookbook once bricks are configured and ready to use
default['gluster']['server']['bricks'] = []
