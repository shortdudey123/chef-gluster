require 'serverspec'

include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

RSpec.configure do |c|
  c.before :all do
    c.path = '/sbin:/usr/sbin'
  end
end

package_name = 
  case os[:family]
  when'RedHat'
    'glusterfs'
  when 'Ubuntu'
    'glusterfs-client'
  end

describe package(package_name) do
  it { should be_installed }
end