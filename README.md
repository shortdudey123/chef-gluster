# gluster Cookbook

[![Build Status](https://travis-ci.org/shortdudey123/chef-gluster.svg)](https://travis-ci.org/shortdudey123/chef-gluster)
[![Cookbook Version](https://img.shields.io/cookbook/v/gluster.svg)](https://supermarket.chef.io/cookbooks/gluster)

This cookbook is used to install and configure Gluster on both servers and clients. This cookbook makes several assumptions when configuring Gluster servers:

1. This cookbook is being run on at least two nodes, the exact number depends on the Gluster Volume type
2. A second physical disk has been added, unformatted, to the server. This cookbook will install lvm and configure the disks automatically.
3. All peers for a volume will be configured with the same number of bricks

## Platforms

This cookbook has been tested on:
- Ubuntu 14.04
- Ubuntu 16.04
- Centos 6.8
- Centos 7.2

As this cookbook uses Semantic Versioning, major version number bumps are not backwards compatible. Especially the change from v4 to v5 will require a rebuild of the gluster nodes.

## Attributes

### gluster::default
- `node['gluster']['version']` - version to install, defaults to 3.8
- `node['gluster']['repo']` - repo to install from: can be public or private, defaults to public, private requires a so-called "private" repo to be configured in a wrapper cookbook for example

### gluster::client
Node attributes to specify volumes to mount. This has been deprecated in favor of using the 'gluster_mount' LWRP.

- `node['gluster']['client']['volumes'][VOLUME_NAME]['server']` - server to connect to
- `node['gluster']['client']['volumes'][VOLUME_NAME]['backup_server']` - name of the backup volfile server to mount the client. When the first volfile server fails, then the server specified here is used as volfile server and is mounted by the client. This can be a String or Array of Strings.
- `node['gluster']['client']['volumes'][VOLUME_NAME]['mount_point']` - mount point to use for the Gluster volume

### gluster::server
Node attributes to specify server volumes to create

The absolute minimum configuration is:
- `node['gluster']['server']['disks']` - an array of disks to create partitions on and format for use with Gluster, (for example, ['/dev/sdb', '/dev/sdc'])
- `node['gluster']['server']['volumes'][VOLUME_NAME]['peers']` - an array of FQDNs for peers used in the volume
- `node['gluster']['server']['volumes'][VOLUME_NAME]['volume_type']` - the volume type to use; this value can be 'replicated', 'distributed-replicated', 'distributed', 'striped' or 'distributed-striped'
- `node['gluster']['server']['volumes'][VOLUME_NAME]['size']` - The size of the gluster volume you would like to create, for example, 100M or 5G. This is passed through to the lvm cookbook and uses the syntax defined here: https://github.com/chef-cookbooks/lvm .

### gluster::geo_replication
Node attributes to specify mountbroker details.

- `node['gluster']['mountbroker]['path']` - The mountbroker path. Defaults to `/var/mountbroker-root`. This does not need to exist beforehand.
- `node['gluster']['mountbroker]['group']` - The mountbroker group. Defaults to `geogroup`. This will be created as a system group if it does not exist already.
- `node['gluster']['mountbroker]['users']` - A hash of users to volumes for allowing access. Empty by default. Multiple volumes can be given as an array. Neither the user or volume needs to exist beforehand. Removing entries does not drop access rights, this must be done manually or via the custom resource.

Other attributes include:
- `node['gluster']['server']['enable']` - enable or disable server service (default enabled)
- `node['gluster']['server']['server_extend_enabled']` - enable or disable server extending support (default enabled)
- `node['gluster']['server']['brick_mount_path']` - default path to use for mounting bricks
- `node['gluster']['server']['disks']` - an array of disks to create partitions on and format for use with Gluster, (for example, ['/dev/sdb', '/dev/sdc'])
- `node['gluster']['server']['peer_retries']` - attempt to connect to peers up to N times
- `node['gluster']['server']['peer_retry_delays']` - number of seconds to wait between attempts to initially attempt to connect to peers
- `node['gluster']['server']['volumes'][VOLUME_NAME]['allowed_hosts']` - an optional array of IP addresses to allow access to the volume
- `node['gluster']['server']['volumes'][VOLUME_NAME]['peer_names']` - an optional array of Chef node names for peers used in the volume
- `node['gluster']['server']['volumes'][VOLUME_NAME]['peers']` - an array of FQDNs for peers used in the volume
- `node['gluster']['server']['volumes'][VOLUME_NAME]['quota']` - an optional disk quota to set for the volume, such as '10GB'
- `node['gluster']['server']['volumes'][VOLUME_NAME]['replica_count']` - the number of replicas to create
- `node['gluster']['server']['volumes'][VOLUME_NAME]['volume_type']` - the volume type to use; this value can be 'replicated', 'distributed-replicated', 'distributed', 'striped' or 'distributed-striped'
- `node['gluster']['server']['volumes'][VOLUME_NAME]['size']` - The size of the gluster volume you would like to create, for example, 100M or 5G. This is passed through to the lvm cookbook.
- `node['gluster']['server']['volumes'][VOLUME_NAME]['filesystem']` - The filesystem to use. This defaults to xfs.
- `node['gluster']['server']['volumes'][VOLUME_NAME]['options']` - Optional options to configure on volume

## Custom Resources

### gluster_volume

Use this resource to start, stop, or delete volumes:

```ruby
gluster_volume 'volume_name' do
  action :start
end
```

```ruby
gluster_volume 'volume_name' do
  action :stop
end
```

```ruby
gluster_volume 'volume_name' do
  action :delete
end
```

It is also useful for checking existence in `only_if` blocks:

```ruby
volume = gluster_volume 'volume_name' do
  action :nothing
end

some_resource 'foo' do
  only_if { volume.current_value }
end
```

```ruby
gluster_volume 'volume_name' do
  action :start
  only_if { current_value }
end
```

#### Parameters

- `volume_name` - The volume name. Defaults to the resource name.

### gluster_mount

Use this resource to mount volumes on clients:

```ruby
gluster_mount 'volume_name' do
  server 'gluster1.example.com'
  backup_server 'gluster2.example.com'
  mount_point '/mnt/gluster/volume_name'
  action [:mount, :enable]
end
```

```ruby
gluster_mount 'volume_name' do
  server 'gluster1.example.com'
  backup_server ['gluster2.example.com', 'gluster3.example.com']
  mount_point '/mnt/gluster/volume_name'
  action [:mount, :enable]
end
```

#### Parameters

- `server` - The primary server to fetch the volfile from. Required.

- `backup_server` - Backup servers to obtain the volfile from. Optional.

- `mount_point` - The mount point on the local server to mount the glusterfs volume on. Created if non-existing. Required.

- `mount_options` - Additional mount options added to the default options set `defaults,_netdev`. Optional.

- `owner` - Owner of the underlying mount point directory. Defaults to `nil`. Optional.

- `group` - Group of the underlying mount point directory. Defaults to `nil`. Optional.

- `mode` - File mode of the underlying mount point directory. Defaults to `nil`. Optional.

### gluster\_volume\_option

Use this resource to set or reset volume options:

```ruby
gluster_volume_option 'volume_name/changelog.rollover-time' do
  value 5
  action :set
end
```

```ruby
gluster_volume_option 'volume_name/changelog.rollover-time' do
  action :reset
end
```

#### Parameters

- `key` - Volume option to change. Required. Derived from after the `/` of resource name if not given.
- `value` - The value to set for the given option. Required for the set action. Booleans are mapped to `on` or `off`.
- `volume` - Volume to chnage. Required. Derived from before the `/` of resource name if not given.

### gluster\_mountbroker\_user

Use this resource to allow or disallow the given user access to the given volume:

```ruby
gluster_mountbroker_user 'user/volume_name' do
  action :add
end
```

```ruby
gluster_mountbroker_user 'user/volume_name' do
  action :remove
end
```

#### Parameters

- `user` - The user to grant permission to. Required. Derived from before the `/` of resource name if not given.
- `volume` - The volume to grant the permission for. Required. Derived from after the `/` of resource name if not given.

## Usage

On two or more identical systems, attach the desired number of dedicated disks to use for Gluster storage. Add the `gluster::server` recipe to the node's run list and add any appropriate attributes, such as volumes to the `['gluster']['server']['volumes']` attribute. If the cookbook will be used to manage disks, add the disks to the `['gluster']['server']['disks']` attribute; otherwise format the disks appropriately and add them to the `['gluster']['server']['volumes'][VOLUME_NAME]['disks']` attribute. Once all peers for a volume have configured their bricks, the 'master' peer (the first in the array) will create and start the volume.

For example, to create a replicated gluster volume named gv0 with 2 bricks on two nodes, add the following to your attributes/default.rb and include the gluster::server recipe:

```
default['gluster']['server']['brick_mount_path'] = "/data"
default['gluster']['server']['volumes'] = {
                'gv0' => {
                        'peers' => ['gluster1.example.com','gluster2.example.com'],
                        'replica_count' => 2,
                        'volume_type' => "replicated"
                }
}
```

To create a distributed-replicated volume with 4 bricks and a replica count of two:

```
default['gluster']['server']['brick_mount_path'] = "/data"
default['gluster']['server']['volumes'] = {
                'gv0' => {
                        'peers' => ['gluster1.example.com','gluster2.example.com','gluster3.example.com','gluster4.example.com'],
                        'replica_count' => 2,
                        'volume_type' => "distributed-replicated"
                }
}
```

To create a replicated volume with 4 bricks:

```
default['gluster']['server']['brick_mount_path'] = "/data"
default['gluster']['server']['volumes'] = {
                'gv0' => {
                        'peers' => ['gluster1.example.com','gluster2.example.com','gluster3.example.com','gluster4.example.com'],
                        'replica_count' => 4,
                        'volume_type' => "replicated"
                }
}
```

For clients, add the gluster::default or gluster::client recipe to the node's run list, and mount volumes using the `gluster_mount` LWRP. The Gluster volume will be mounted on the next chef-client run (provided the volume exists and is available) and added to /etc/fstab.

This cookbook cannot currently perform all the steps required for geo-replication but it can configure the mountbroker. The `gluster::mountbroker` recipe calls upon the `gluster::geo_replication_install` recipe to install the necessary package before configuring the mountbroker according to the `['gluster']['mountbroker']` attributes. User access can be defined via the attributes or you can use the `gluster_mountbroker_user` custom resource directly. Both the recipe and resource require Gluster 3.9 or later.

## Testing

There is a kitchen file provided to allow testing of the various versions. Examples of tests are:

(Depending on your shell, you may or may not need the \ in the RegEx)

To test a replicated volume on Ubuntu 16.04:
kitchen converge replicated\[12]-ubuntu-1604
kitchen verify replicated2-ubuntu-1604

To test a distributed-replicated volume on CentOS 7.2:
kitchen converge distributed-repl\[1234]-centos-72
kitchen verify distributed-repl4-centos-72

To test a striped volume on CentOS 6.8:
kitchen converge striped\[12]-centos-68
kitchen verify striped2-centos-68

To test a fuse client on Ubuntu 14.04:
kitchen converge client\[12]-ubuntu-1404
kitchen verify client2-ubuntu-1404

Please note that at present the kitchen setup only supports Virtualbox
