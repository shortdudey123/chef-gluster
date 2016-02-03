#
# Cookbook Name:: gluster
# Recipe:: server_setup
#
# Copyright 2015, Andrew Repton
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
node['gluster']['server']['volumes'].each do |volume_name, volume_values|
  # 1. Get the current size of the logical volume
  # 2. Compare to the size set for the gluster volume
  # 3. If different, run a resize action against that volume
  # ToDO: change hardcoded VG name gluster into an attribute
  require 'lvm'

  LVM::LVM.new do |lvm|
    lvm.logical_volumes.each do |lv|
      # I'm ignoring these as I think this layout helps readability
      # rubocop:disable Style/Next, Style/CaseIndentation, Lint/EndAlignment
      if lv.full_name.to_s == "gluster/#{volume_name}"
        lv_size_cur = lv.size.to_i
        # Borrowed from the lvm cookbook
        volume_lv_size_req = case volume_values['size']
          when /^(\d+)(k|K)$/
            (Regexp.last_match[1].to_i * 1024)
          when /^(\d+)(m|M)$/
            (Regexp.last_match[1].to_i * 1_048_576)
          when /^(\d+)(g|G)$/
            (Regexp.last_match[1].to_i * 1_073_741_824)
          when /^(\d+)(t|T)$/
            (Regexp.last_match[1].to_i * 1_099_511_627_776)
          when /^(\d+)$/
            Regexp.last_match[1].to_i
          else
            Chef::Application.fatal!("Invalid size #{Regexp.last_match[1]} for lvm resize")
          end
        if volume_lv_size_req > lv_size_cur
          Chef::Log.warn("Requested size #{volume_lv_size_req} is larger than current size #{lv_size_cur}, resizing volume")
          lvm_logical_volume volume_name do
            size volume_values['size']
            group 'gluster'
            action :resize
          end
        elsif volume_lv_size_req < lv_size_cur
          Chef::Log.fatal("Requested size #{volume_lv_size_req} is smaller than current size #{lv_size_cur}, I am not resizing")
        else
          Chef::Log.info('Size is the same, doing nothing')
        end
      end
    end
  end
end
