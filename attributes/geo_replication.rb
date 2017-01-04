#
# Cookbook Name:: gluster
# Attributes:: geo_replication
#
# Copyright 2016, Yakara Ltd
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

# geo-replication package
default['gluster']['geo_replication']['package'] = value_for_platform_family(
  'debian' => 'glusterfs-common',
  'default' => 'glusterfs-geo-replication'
)

# Debian's 3.9 package is missing the PATH symlink for some reason
default['gluster']['mountbroker']['command'] = value_for_platform_family(
  'debian' => '/usr/lib/x86_64-linux-gnu/glusterfs/peer_mountbroker.py',
  'default' => 'gluster-mountbroker'
)

# Mountbroker settings
default['gluster']['mountbroker']['path'] = '/var/mountbroker-root'
default['gluster']['mountbroker']['group'] = 'geogroup'
default['gluster']['mountbroker']['users'] = {}
