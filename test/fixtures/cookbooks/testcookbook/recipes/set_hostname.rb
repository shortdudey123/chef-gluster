#
# Cookbook Name:: testcookbook
# Recipe:: chef-gluster
#
# Author:: Andrew Repton. <arepton@schubergphilis.com>
#
# Licensed 'Apache 2.0'
#

['192.168.10.10 gluster1', '192.168.10.20 gluster2', '192.168.10.30 gluster3', '192.168.10.40 gluster4'].each do |glusternode|
  execute "set_hostnames for #{glusternode}" do
    command "echo #{glusternode} >> /etc/hosts"
  end
end

if node['platform_family'] == 'rhel' && node['platform_version'].to_i == 7
  execute 'fix_network' do
    command 'service NetworkManager stop && service network restart'
  end
end
