require 'spec_helper'

describe 'gluster::server.rb' do
  describe command('gluster volume list') do
    its(:stdout) { should match 'gv0' }
  end

  describe command('gluster volume status') do
    its(:stdout) { should include('Brick gluster1:/data/gv0/brick') }
  end

  describe command('gluster volume info') do
    its(:stdout) { should include('Type: Stripe') }
    its(:stdout) { should include('Number of Bricks: 1 x 2 = 2') }
    its(:stdout) { should include('gluster2:/data/gv0/brick') }
    its(:stdout) { should include('gluster1:/data/gv0/brick') }
  end
end
