node['gluster']['server']['volumes'].each do |volume_name, volume_values|
  brick_count = 0
  # If I am the new guy, I do not want to be running the below code!
  unless File.exist?("/var/lib/glusterd/vols/#{volume_name}/info")
    Chef::Log.warn('I can\'t invite myself into the pool!')
    break
  end

  unless node.default['gluster']['server']['volumes'][volume_name].attribute?('bricks_waiting_to_join')
    node.default['gluster']['server']['volumes'][volume_name]['bricks_waiting_to_join'] = ''
  end

  # We want to check if a new peer has been added to the attribute node['gluster']['server']['volumes']['$volume_name']['peers'].
  # The first server that was ALREADY in the gluster pool after the new one has run chef will reach this point of the code (it will have probed the new one in)
  peers = volume_values.attribute?('peer_names') ? volume_values['peer_names'] : volume_values['peers']
  peers.each do |peer|
    begin
      chef_node = Chef::Node.load(peer)
    rescue Net::HTTPServerException
      Chef::Log.warn("Unable to find a chef node for #{peer}")
      next
    end

    peer_bricks = chef_node['gluster']['server']['volumes'][volume_name]['bricks'].select { |brick| brick.include? volume_name }
    brick_count += (peer_bricks.count || 0)
    peer_bricks.each do |brick|
      peer_name = if volume_values.attribute?('peer_names')
                    volume_values['peers'][peers.index(peer)]
                  else
                    peer
                  end
      Chef::Log.info("Checking #{peer_name}:#{brick}")
      unless brick_in_volume?(peer_name, brick, volume_name)
        node.default['gluster']['server']['volumes'][volume_name]['bricks_waiting_to_join'] << " #{peer_name}:#{brick}"
      end
    end
  end

  replica_count = volume_values['replica_count']
  next if node['gluster']['server']['volumes'][volume_name]['bricks_waiting_to_join'].empty?
  # The number of bricks in bricks_waiting_to_join has to be a modulus of the replica_count we are using for our gluster volume
  if (brick_count % replica_count).zero?
    Chef::Log.info("Attempting to add new bricks into volume #{volume_name}")
    execute "gluster volume add-brick #{volume_name} #{node['gluster']['server']['volumes'][volume_name]['bricks_waiting_to_join']}" do
      action :run
    end
    node.normal['gluster']['server']['volumes'][volume_name]['bricks_waiting_to_join'] = ''
  elsif volume_values['volume_type'] == 'striped'
    Chef::Log.warn("#{volume_name} is a striped volume, adjusting replica count to match new number of bricks")
    node.normal['gluster']['server']['volumes'][volume_name][replica_count] = brick_count
    execute "gluster volume add-brick #{volume_name} stripe #{brick_count} #{node['gluster']['server']['volumes'][volume_name]['bricks_waiting_to_join']}" do
      action :run
    end
    node.normal['gluster']['server']['volumes'][volume_name]['bricks_waiting_to_join'] = ''
  elsif volume_values['volume_type'] == 'replicated'
    Chef::Log.warn("#{volume_name} is a replicated volume, adjusting replica count to match new number of bricks")
    node.normal['gluster']['server']['volumes'][volume_name][replica_count] = brick_count
    execute "gluster volume add-brick #{volume_name} replica #{brick_count} #{node['gluster']['server']['volumes'][volume_name]['bricks_waiting_to_join']}" do
      action :run
    end
    node.normal['gluster']['server']['volumes'][volume_name]['bricks_waiting_to_join'] = ''
  else
    Chef::Log.warn("There are #{brick_count} bricks waiting to be added to #{volume_name}, but the replica count is #{replica_count}. \
    I will wait until a modulus of the replica count is available. The bricks to be added are #{node['gluster']['server']['bricks_waiting_to_join']}")
  end
end
