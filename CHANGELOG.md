# gluster cookbook CHANGELOG

## v4.0.1 (2015-09-30)
- **[PR #28](https://github.com/shortdudey123/chef-gluster/pull/28)** - Add exception handling for peers not being nodes on chef server
- **[PR #36](https://github.com/shortdudey123/chef-gluster/pull/36)** - Allow disabling of public Gluster repo
- **[PR #37](https://github.com/shortdudey123/chef-gluster/pull/37)** - Fix default attribute value for `['gluster']['client']['volumes']`
- **[PR #37](https://github.com/shortdudey123/chef-gluster/pull/37)** - Add include for client_mount recipe in client recipe


## v4.0.0 (2015-08-28)
- **[PR #17](https://github.com/shortdudey123/chef-gluster/pull/17)** - Allow hostname for older versions of chef-server
- **[PR #18](https://github.com/shortdudey123/chef-gluster/pull/18)** - Fix for initial Chef run for the first node in a cluster
- **[PR #21](https://github.com/shortdudey123/chef-gluster/pull/21)** - Add ability to disable gluster server service
- **[PR #22](https://github.com/shortdudey123/chef-gluster/pull/22)** - Fix Ruby syntax, add Rubocop, add Foodcritic, add TravisCI
- **[PR #27](https://github.com/shortdudey123/chef-gluster/pull/27)** - Add glusterfsd service for shutdown cleanup on RHEL 7+
- **[PR #24](https://github.com/shortdudey123/chef-gluster/pull/24)** - Wait until peer reaches connected status before continuing
- **[PR #24](https://github.com/shortdudey123/chef-gluster/pull/24)** - Add striped, distributed, distributed-striped volume types
- **[PR #24](https://github.com/shortdudey123/chef-gluster/pull/24)** - Fix chef node loading
- **[PR #24](https://github.com/shortdudey123/chef-gluster/pull/24)** - Add server_extend recipe to allow for automatic gluster scaling

## v3.1.0 (2015-07-09)
- **[PR #6](https://github.com/shortdudey123/chef-gluster/pull/6)** - Allow to multiple backup servers when mounting a glusterfs volume
- **[PR #7](https://github.com/shortdudey123/chef-gluster/pull/7)** - Add recursive true for dir creation under the lvm logic
- **[PR #9](https://github.com/shortdudey123/chef-gluster/pull/9)** - Fix Ruby syntax on create partition bash block
- **[PR #9](https://github.com/shortdudey123/chef-gluster/pull/9)** - Create a "servicename" attribute so that the service-hook actually starts the correctly named service.
- **[PR #10](https://github.com/shortdudey123/chef-gluster/pull/10)** - Modify order of saving the bricks
- **[PR #13](https://github.com/shortdudey123/chef-gluster/pull/13)** - Add peer_names attribute to volumes
- **[PR #14](https://github.com/shortdudey123/chef-gluster/pull/14)** - Retry peering
- **[PR #16](https://github.com/shortdudey123/chef-gluster/pull/16)** - Don't shadow bricks variable

## v3.0.1 (2015-03-25)
- **[PR #2](https://github.com/shortdudey123/chef-gluster/pull/2)** - Fix typo for brick_mount_path attribute
- Relaxed brick count check for replicated volumes

## v3.0.0 (2015-03-20)
- Added a new `gluster_mount` LWRP
- Deprecating `gluster::client_mount` recipe
- Updated Ubuntu repo location

## v2.1.1 (2015-02-17)
- Added backup server option for gluster::client_mount


## v2.1.0 (2014-08-29)
- Initial commit
