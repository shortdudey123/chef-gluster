def node_peer?(node)
  cmd = shell_out("gluster pool list | awk '{print $2}' | grep #{node}")
  # cmd.stdout has a \n at the end of it
  # rubocop:disable Style/GuardClause
  if cmd.stdout.chomp == node
    return true
  else
    return false
  end
end

def peer_in_volume?(peer, volume)
  cmd = shell_out("gluster volume info #{volume} | awk '{print $2}' | awk -F : '{print $1}' | grep #{peer} | uniq")
  # cmd.stdout has a \n at the end of it
  if cmd.stdout.chomp == node
    return true
  else
    return false
  end
end

def brick_in_volume?(peer, brick, volume)
  cmd = shell_out("gluster volume info #{volume} | awk '{print $2}' | grep #{peer}:#{brick}")
  # cmd.stdout has a \n at the end of it
  if cmd.stdout.chomp == "#{peer}:#{brick}"
    return true
  else
    return false
  end
end
