#
# Cookbook Name:: gluster
# Resource:: volume_option
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
# volume/key

property :volume, String,
         required: true,
         default: lazy { name.scan(%r{\A[^/]+(?=/)}).first }

property :key, String,
         required: true,
         default: lazy { name.scan(%r{(?<=/)[^/]+\Z}).first }

property :value, [String, Integer, TrueClass, FalseClass],
         required: true,
         coerce: proc { |v| value_string v }

default_action :set

load_current_value do
  cmd = shell_out('gluster', 'volume', 'get', volume, key)

  case cmd.exitstatus
  when 0
    value cmd.stdout.chomp.lines.last.split(nil, 2).last.rstrip
    value nil if value == '(null)'
  when 2
    current_value_does_not_exist!
  else
    cmd.error!
  end
end

action :set do
  converge_if_changed do
    shell_out!('gluster', 'volume', 'set', volume, key, value)
  end
end

action :reset do
  if current_resource # ~FC023
    converge_by ['reset value to default'] do
      shell_out!('gluster', 'volume', 'reset', volume, key)
    end
  end
end

def value_string(v = value)
  case v
  when NilClass
    nil
  when TrueClass
    'on'
  when FalseClass
    'off'
  else
    v.to_s
  end
end
