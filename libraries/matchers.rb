if defined?(ChefSpec)
  def mount_gluster_mount(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gluster_mount, :mount, resource_name)
  end

  def umount_gluster_mount(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gluster_mount, :umount, resource_name)
  end

  def enable_gluster_mount(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gluster_mount, :enable, resource_name)
  end

  def disable_gluster_mount(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gluster_mount, :disable, resource_name)
  end

  def set_gluster_volume_option(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gluster_volume_option, :set, resource_name)
  end

  def reset_gluster_volume_option(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gluster_volume_option, :reset, resource_name)
  end
end
