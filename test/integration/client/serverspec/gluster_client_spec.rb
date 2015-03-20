require 'spec_helper'

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
