name             'gluster'
maintainer       'Grant Ridder'
maintainer_email 'shortdudey123@gmail.com'
license          'Apache 2.0'
description      'Installs and configures Gluster servers and clients'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '5.0.1'
depends          'apt', '>= 2.0'
depends          'yum', '>= 3.0'
depends          'lvm', '>= 1.5.1'

source_url 'https://github.com/shortdudey123/chef-gluster' if respond_to?(:source_url)
issues_url 'https://github.com/shortdudey123/chef-gluster/issues' if respond_to?(:issues_url)
