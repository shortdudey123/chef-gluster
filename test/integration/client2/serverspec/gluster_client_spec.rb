require 'spec_helper'

package_name =
  case os[:family]
  when 'redhat'
    'glusterfs-fuse'
  when 'ubuntu'
    'glusterfs-client'
  end

describe 'gluster::client' do
  describe package(package_name) do
    it { should be_installed }
  end

  describe command('df /mnt/gv0/') do
    its(:stdout) { should include('gluster2:/gv0') }
  end

  describe command('mount') do
    its(:stdout) { should include('gluster2:/gv0 on /mnt/gv0 type fuse.glusterfs') }
  end

  describe file('/etc/fstab') do
    it { should be_file }
    # its(:content) { should match(/^interface: 0.0.0.0/) }
    its(:content) { should match %r{^gluster2:/gv0 /mnt/gv0 glusterfs defaults,_netdev,backupvolfile-server=gluster1 0 0$} }
  end
end
