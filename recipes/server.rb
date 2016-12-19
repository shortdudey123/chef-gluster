#
# Cookbook Name:: gluster
# Recipe:: server
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

include_recipe 'gluster::server_install'
include_recipe 'lvm'
include_recipe 'gluster::server_setup'
include_recipe 'gluster::server_extend' if node['gluster']['server']['server_extend_enabled']
include_recipe 'gluster::volume_extend' if begin
                                             Gem::Specification.find_by_name('di-ruby-lvm')
                                           rescue Gem::LoadError
                                             Chef::Log.info('not including gluster::volume_extend since di-ruby-lvm was not found')
                                             return false
                                           end
