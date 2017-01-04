#
# Cookbook Name:: gluster
# Recipe:: mountbroker
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

include_recipe 'gluster::geo_replication_install'

mb = node['gluster']['mountbroker']

group mb['group'] do
  system true
end

execute 'gluster-mountbroker setup' do
  command [node['gluster']['mountbroker']['command'], 'setup', mb['path'], mb['group']]
  notifies :restart, "service[#{node['gluster']['server']['servicename']}]"

  not_if do
    json = Chef::JSONCompat.parse shell_out!(node['gluster']['mountbroker']['command'], 'node-status').stdout
    json['output']['mountbroker-root'] == mb['path'] &&
      json['output']['geo-replication-log-group'] == mb['group']
  end
end

mb['users'].each do |user, volumes|
  Array(volumes).each do |volume|
    gluster_mountbroker_user "#{user}/#{volume}"
  end
end
