#
# Cookbook Name:: gluster
# Recipe:: repository
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

case node['platform']
when 'debian'
  include_recipe 'apt::default'

  apt_repository "glusterfs-#{node['gluster']['version']}" do
    uri "http://download.gluster.org/pub/gluster/glusterfs/#{node['gluster']['version']}/LATEST/Debian/#{node['lsb']['codename']}/apt"
    distribution node['lsb']['codename']
    components ['main']
    key "http://download.gluster.org/pub/gluster/glusterfs/#{node['gluster']['version']}/LATEST/Debian/#{node['lsb']['codename']}/pubkey.gpg"
    deb_src true
    not_if do
      File.exist?("/etc/apt/sources.list.d/glusterfs-#{node['gluster']['version']}.list")
    end
  end
when 'ubuntu'
  include_recipe 'apt::default'

  apt_repository "glusterfs-#{node['gluster']['version']}" do
    uri "http://ppa.launchpad.net/gluster/glusterfs-#{node['gluster']['version']}/ubuntu"
    distribution node['lsb']['codename']
    components ['main']
    keyserver 'keyserver.ubuntu.com'
    key '3FE869A9'
    deb_src true
    not_if do
      File.exist?("/etc/apt/sources.list.d/glusterfs-#{node['gluster']['version']}.list")
    end
  end
when 'redhat', 'centos'
  yum_repository 'glusterfs' do
    url "http://download.gluster.org/pub/gluster/glusterfs/#{node['gluster']['version']}/LATEST/EPEL.repo/epel-$releasever/$basearch/"
    gpgcheck false
    action :create
  end
end
