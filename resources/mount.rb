#
# Cookbook Name:: gluster
# Resource:: mount
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

actions :mount, :umount, :enable, :disable
default_action :mount

attribute :name, kind_of: String, name_attribute: true
attribute :server, kind_of: String, default: nil, required: true
attribute :owner, kind_of: String, default: nil
attribute :group, kind_of: String, default: nil
attribute :mode, kind_of: String, default: nil
attribute :backup_server, kind_of: [String, Array], default: nil
attribute :mount_point, kind_of: String, default: nil, required: true
attribute :mount_options, kind_of: [String, Array], default: nil
