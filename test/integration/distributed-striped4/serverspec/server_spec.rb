require 'spec_helper'

describe 'gluster::server.rb' do
  describe command('gluster volume list') do
    its(:stdout) { should match 'gv0' }
  end

  describe command('gluster volume status') do
    its(:stdout) { should include('Brick gluster1:/data/sdb1/gv0') }
  end

  describe command('gluster volume info') do
    its(:stdout) { should include('Type: Distributed-Stripe') }
    its(:stdout) { should include('Number of Bricks: 2 x 2 = 4') }
    its(:stdout) { should include('gluster4:/data/sdb1/gv0') }
    its(:stdout) { should include('gluster3:/data/sdb1/gv0') }
    its(:stdout) { should include('gluster2:/data/sdb1/gv0') }
    its(:stdout) { should include('gluster1:/data/sdb1/gv0') }
  end
end
