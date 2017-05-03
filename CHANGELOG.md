# gluster cookbook CHANGELOG

## Unreleased

## v6.2.0 (2017-05-03)
- **[PR #96](https://github.com/shortdudey123/chef-gluster/pull/96)** - Update kitchen-vagrant
- **[PR #97](https://github.com/shortdudey123/chef-gluster/pull/97)** - Fetch 3.9 and 3.10 RPMs from mirror.centos.org now they're availabl
- **[PR #98](https://github.com/shortdudey123/chef-gluster/pull/98)** - Fix failure to set initially ungettable volume options like client.ssl
- **[PR #100](https://github.com/shortdudey123/chef-gluster/pull/100)** - remove `s` in backupvolfile-server in mount provider
- **[PR #101](https://github.com/shortdudey123/chef-gluster/pull/101)** - Fixup foodcritic and rubocop offenses

## v6.1.0 (unrelased, changes will be released in next version)
- **[PR #94](https://github.com/shortdudey123/chef-gluster/pull/94)** - Add gluster_volume custom resource

## v6.0.0 (2017-01-03)
- **[PR #92](https://github.com/shortdudey123/chef-gluster/pull/92)** - Depend on compat_resource instead of apt and yum cookbooks
- **[PR #93](https://github.com/shortdudey123/chef-gluster/pull/93)** - Drop support for Chef < 12.1

## v5.3.0 (2017-01-03)
- **[PR #82](https://github.com/shortdudey123/chef-gluster/pull/82)** - Add license and fix readme
- **[PR #83](https://github.com/shortdudey123/chef-gluster/pull/83)** - Use GPG keys on yum repositories and Support 3.9 on yum via the buildlogs.centos.org testing repo
- **[PR #84](https://github.com/shortdudey123/chef-gluster/pull/84)** - Allow disable of server extending support
- **[PR #85](https://github.com/shortdudey123/chef-gluster/pull/85)** - Minor Debian and repository fixes
- **[PR #86](https://github.com/shortdudey123/chef-gluster/pull/86)** - Add gluster_volume_option custom resource
- **[PR #90](https://github.com/shortdudey123/chef-gluster/pull/90)** - Add parameters for volume_option to README
- **[PR #91](https://github.com/shortdudey123/chef-gluster/pull/91)** - Allow specify options as attributes

## v5.2.0 (2016-12-09)
- **[PR #77](https://github.com/shortdudey123/chef-gluster/pull/77)** - Allow use gluster recipe on already existed filesystem
- **[PR #78](https://github.com/shortdudey123/chef-gluster/pull/78)** - Allow customize brick directory by attribute
- **[PR #79](https://github.com/shortdudey123/chef-gluster/pull/79)** - Fix gluster volume create force

## v5.1.0 (2016-12-02)
- **[PR #72](https://github.com/shortdudey123/chef-gluster/pull/72)** - Fix backup-volfile-server(s) in mount provider
- **[PR #73](https://github.com/shortdudey123/chef-gluster/pull/73)** - Bump Travis ruby version to 2.3.1
- **[PR #74](https://github.com/shortdudey123/chef-gluster/pull/74)** - Bump Gluster version to 3.8
- **[PR #75](https://github.com/shortdudey123/chef-gluster/pull/75)** - Disable Metrics/BlockLength cop

## v5.0.2 (2016-09-14)
- **[PR #58](https://github.com/shortdudey123/chef-gluster/pull/58)** - Fix case statement syntax
- **[PR #59](https://github.com/shortdudey123/chef-gluster/pull/59)** - Fix problems with volume_extend recipe
- **[PR #61](https://github.com/shortdudey123/chef-gluster/pull/61)** - Update disk controller logic for Vagrant template
- **[PR #62](https://github.com/shortdudey123/chef-gluster/pull/62)** - Fix undefined method error in server_extend recipe
- **[PR #63](https://github.com/shortdudey123/chef-gluster/pull/63)** - Fix Ruby syntax per Rubocop
- **[PR #66](https://github.com/shortdudey123/chef-gluster/pull/66)** - Update test-kitchen OS's
- **[PR #67](https://github.com/shortdudey123/chef-gluster/pull/67)** - Fix serverspec verification
- **[PR #68](https://github.com/shortdudey123/chef-gluster/pull/68)** - Add kitchen testing for gluster::client recipe
- **[PR #69](https://github.com/shortdudey123/chef-gluster/pull/69)** - Update yum_repository resource

## v5.0.1 (2016-03-12)
- **[PR #52](https://github.com/shortdudey123/chef-gluster/pull/52)** - Correct the usage of the peer_names attribute
- **[PR #53](https://github.com/shortdudey123/chef-gluster/pull/53)** - Fix spacing in case statement
- **[PR #56](https://github.com/shortdudey123/chef-gluster/pull/56)** - Allow host check to match when hostname is listed under 'Other names'
- **[PR #57](https://github.com/shortdudey123/chef-gluster/pull/57)** - Add source_url and issues_url to metadata

## v5.0.0 (2016-02-03)
- **[PR #44](https://github.com/shortdudey123/chef-gluster/pull/44)** - Fix brick_in_volume for long hostnames
- **[PR #47](https://github.com/shortdudey123/chef-gluster/pull/47)** - Re-architecture of gluster cookbook to support multi-volume per peer, LVM, size declaration
- **[PR #48](https://github.com/shortdudey123/chef-gluster/pull/48)** - Add Debian support
- **[PR #51](https://github.com/shortdudey123/chef-gluster/pull/51)** - Update repo for Centos 6/7

## v4.0.2 (2015-10-21)
- **[PR #39](https://github.com/shortdudey123/chef-gluster/pull/39)** - Fix the client package name for rhel
- **[PR #42](https://github.com/shortdudey123/chef-gluster/pull/42)** - Add owner/group/mode settings to gluster_mount LWRP
- **[PR #41](https://github.com/shortdudey123/chef-gluster/pull/41)** - Allow mount options to be set on gluster mount

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
