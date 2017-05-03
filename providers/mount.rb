#
# Cookbook Name:: gluster
# Provider:: mount
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

def whyrun_supported?
  true
end

use_inline_resources if defined?(use_inline_resources)

action :mount do
  set_updated { create_mount_point }
  set_updated { mount_volume }
end

action :umount do
  set_updated { unmount_volume }
end

action :enable do
  set_updated { enable_volume }
end

action :disable do
  set_updated { disable_volume }
end

def create_mount_point
  # Ensure the mount point exists
  directory new_resource.mount_point do
    recursive true
    owner new_resource.owner
    group new_resource.group
    mode new_resource.mode
    action :create
  end
end

def disable_volume
  mount new_resource.mount_point do
    device "#{new_resource.server}:/#{new_resource.name}"
    action :disable
  end
end

def enable_volume
  mount new_resource.mount_point do
    device "#{new_resource.server}:/#{new_resource.name}"
    fstype 'glusterfs'
    options mount_options
    pass 0
    action :enable
  end
end

def mount_options
  "#{basic_mount_options}#{mount_options_for_backup_server}"
end

def basic_mount_options
  [
    'defaults,_netdev',
    new_resource.mount_options || []
  ].flatten(1).join(',')
end

def mount_options_for_backup_server
  case new_resource.backup_server
  when String
    ',backupvolfile-server=' + new_resource.backup_server
  when Array
    ',backupvolfile-server=' + new_resource.backup_server.join(':')
  end
end

def mount_volume
  mount new_resource.mount_point do
    device "#{new_resource.server}:/#{new_resource.name}"
    fstype 'glusterfs'
    options mount_options
    pass 0
    action :mount
  end
end

def set_updated
  r = yield
  new_resource.updated_by_last_action(r.updated_by_last_action?)
end

def unmount_volume
  mount new_resource.mount_point do
    device "#{new_resource.server}:/#{new_resource.name}"
    action :umount
  end
end
