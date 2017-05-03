name             'gluster'
maintainer       'Grant Ridder'
maintainer_email 'shortdudey123@gmail.com'
license          'Apache-2.0'
description      'Installs and configures Gluster servers and clients'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '6.2.0'
depends          'compat_resource', '>= 12.14.6'
depends          'lvm', '>= 1.5.1'

source_url 'https://github.com/shortdudey123/chef-gluster'
issues_url 'https://github.com/shortdudey123/chef-gluster/issues'
chef_version '>= 12.1'

supports 'centos'
supports 'ubuntu'
