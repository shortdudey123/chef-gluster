#
# Cookbook Name:: gluster
# Resource:: volume
#
# Copyright 2017, Yakara Ltd
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

property :volume_name, String,
         name_property: true

property :started, [TrueClass, FalseClass]

default_action :nothing

load_current_value do
  cmd = shell_out('gluster', 'volume', 'info', volume_name)

  if cmd.error?
    current_value_does_not_exist!
  else
    started !(cmd.stdout =~ /^Status: Started$/).nil?
  end
end

action :start do
  unless current_resource.started # ~FC023
    converge_by ["start volume #{volume_name}"] do
      shell_out!('gluster', 'volume', 'start', volume_name)
    end
  end
end

action :stop do
  if current_resource.started # ~FC023
    converge_by ["stop volume #{volume_name}"] do
      shell_out!('gluster', 'volume', 'stop', volume_name, input: "y\n")
    end
  end
end

action :delete do
  if current_resource # ~FC023
    converge_by ["delete volume #{volume_name}"] do
      shell_out!('gluster', 'volume', 'delete', volume_name, input: "y\n")
    end
  end
end
