#
# Cookbook Name:: gluster
# Resource:: mountbroker_user
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

# name property should take the form:
# user/volume

property :user, String,
         required: true,
         default: lazy { name.scan(%r{\A[^/]+(?=/)}).first }

property :volume, String,
         required: true,
         default: lazy { name.scan(%r{(?<=/)[^/]+\Z}).first }

default_action :add

load_current_value do
  json = Chef::JSONCompat.parse shell_out!(node['gluster']['mountbroker']['command'], 'node-status').stdout
  volumes = json['output']['users'][user]

  unless volumes.is_a?(Array) && volumes.include?(volume)
    current_value_does_not_exist!
  end
end

action :add do
  converge_if_changed do
    shell_out!(node['gluster']['mountbroker']['command'], 'add', volume, user)
  end
end

action :remove do
  unless current_resource.nil? # ~FC023
    converge_by ['remove the user/volume pair'] do
      shell_out!(node['gluster']['mountbroker']['command'], 'remove', '--volume', volume, '--user', user)
    end
  end
end
