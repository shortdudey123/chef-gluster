gluster Cookbook
================

[![Build Status](https://travis-ci.org/shortdudey123/chef-gluster.svg)](https://travis-ci.org/shortdudey123/chef-gluster)

This cookbook is used to install and configure Gluster on both servers and clients. This cookbook makes several assumptions when configuring Gluster servers:

1. If using the cookbook to format disks, each disk will contain a single partition dedicated for Gluster
2. Non-replicated volume types are not supported
3. All peers for a volume will be configured with the same number of bricks

Platforms
---------
This cookbook has been tested on Ubuntu 12.04/14.04, CentOS 6.5 and CentOS 7.1
Also on debian wheezy, but it should work on any above as well.

Attributes
----------

### gluster::default
- `node['gluster']['version']` - version to install, defaults to 3.4
- `node['gluster']['repo']` - repo to install from: can be public or private, defaults to public, private requires a so-called "private" repo to be configured in a wrapper cookbook for example

### gluster::client
Node attributes to specify volumes to mount. This has been deprecated in favor of using the 'gluster_mount' LWRP.

- `node['gluster']['client']['volumes'][VOLUME_NAME]['server']` - server to connect to
- `node['gluster']['client']['volumes'][VOLUME_NAME]['backup_server']` - name of the backup volfile server to mount the client. When the first volfile server fails, then the server specified here is used as volfile server and is mounted by the client. This can be a String or Array of Strings.
- `node['gluster']['client']['volumes'][VOLUME_NAME]['mount_point']` - mount point to use for the Gluster volume

### gluster::server
Node attributes to specify server volumes to create

- `node['gluster']['server']['brick_mount_path']` - default path to use for mounting bricks
- `node['gluster']['server']['disks']` - an array of disks to create partitions on and format for use with Gluster, (for example, ['sdb', 'sdc'])
- `node['gluster']['server']['peer_retries']` - attempt to connect to peers up to N times
- `node['gluster']['server']['peer_retry_delays']` - number of seconds to wait between attempts to initially attempt to connect to peers
- `node['gluster']['server']['volumes'][VOLUME_NAME]['allowed_hosts']` - an optional array of IP addresses to allow access to the volume
- `node['gluster']['server']['volumes'][VOLUME_NAME]['disks']` - an optional array of disks to put bricks on (for example, ['sdb', 'sdc']); by default the cookbook will use the first x number of disks, equal to the replica count
- `node['gluster']['server']['volumes'][VOLUME_NAME]['lvm_volumes']` - an optional array of logical volumes to put bricks on (for example, ['LogVolGlusterBrick1', 'LogVolGlusterBrick2']); by default the cookbook will use the first x number of volumes, equal to the replica count
- `node['gluster']['server']['volumes'][VOLUME_NAME]['peer_names']` - an optional array of Chef node names for peers used in the volume
- `node['gluster']['server']['volumes'][VOLUME_NAME]['peers']` - an array of FQDNs for peers used in the volume
- `node['gluster']['server']['volumes'][VOLUME_NAME]['quota']` - an optional disk quota to set for the volume, such as '10GB'
- `node['gluster']['server']['volumes'][VOLUME_NAME]['replica_count']` - the number of replicas to create
- `node['gluster']['server']['volumes'][VOLUME_NAME]['volume_type']` - the volume type to use; this value can be 'replicated', 'distributed-replicated', 'distributed', 'striped' or 'distributed-striped'

LWRPs
-----
Use the gluster_mount LWRP to mount volumes on clients:

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

### Parameters

- `server` - The primary server to fetch the volfile from. Required.

- `backup_server` - Backup servers to obtain the volfile from. Optional.

- `mount_point` - The mount point on the local server to mount the glusterfs volume on. Created if non-existing. Required.

- `mount_options` - Additional mount options added to the default options set `defaults,_netdev`. Optional.

- `owner` - Owner of the underlying mount point directory. Defaults to `nil`. Optional.

- `group` - Group of the underlying mount point directory. Defaults to `nil`. Optional.

- `mode` - File mode of the underlying mount point directory. Defaults to `nil`. Optional.

Usage
-----

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

Testing
-------

There is a kitchen file provided to allow testing of the various versions. Examples of tests are:

(Depending on your shell, you may or may not need the \ in the RegEx)

To test a replicated volume on Ubuntu 12.04:
kitchen converge replicated\[12]-ubuntu-1204
kitchen verify replicated2-ubuntu-1204

To test a distributed-replicated volume on CentOS 7.1:
kitchen converge distributed-repl\[1234]-centos-71
kitchen verify distributed-repl4-centos-71

To test a striped volume on CentOS 6.5:
kitchen converge striped\[12]-centos-65
kitchen verify striped2-centos-65

Please note that at present the kitchen setup only supports Virtualbox
