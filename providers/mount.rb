#
# Cookbook Name:: gluster
# Provider:: mount
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
  # Define a backup server for this volume, if available
  options = 'defaults,_netdev'
  unless new_resource.backup_server.nil?
    case
      when new_resource.backup_server.class == String
        options += ',backupvolfile-server=' + new_resource.backup_server
      when new_resource.backup_server.class == Array
        options += ',backupvolfile-server=' + new_resource.backup_server.join(",backupvolfile-server=")
    end
  end
  options
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
