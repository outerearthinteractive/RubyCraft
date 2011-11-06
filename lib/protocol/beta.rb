class BetaProtocol
  def init_packets
    @players
    @last_keep_alive = 0
    @delim = "\xA7".force_encoding("UTF-16")
    @packets = BetaPacket.list
  end

  def initialize server
    @server = server
    @log = server.log
    @config = server.config
    @players = server.players
    init_packets()
    @log.info("BetaProtocol Enabled!")
  end

  def read_packet connection, packet
    packet_id = packet[0,1].unpack("C")[0]
    @log.debug("Recieved Packet Id: #{packet_id}")
    #puts "Received Packet: "+@packets.key(packet_id).to_s
    case packet_id
    when @packets[:keep_alive]
      keep_alive connection
    when @packets[:server_list_ping]
      server_list_ping connection, packet
    when @packets[:login_request]
      login_request connection, packet
    when @packets[:handshake]
      handshake connection, packet
    else
      @log.info("TODO: Implement #{packet_id}")
      send_kick connection, "TODO: Implement #{packet_id}"
    end

  end

  def handshake connection, packet
    payload =  [@packets[:handshake]]
    payload.concat(BetaPacket.string16 "-")
    connection.send_data BetaPacket.bisect(payload).pack("C*")
  end

  def login_request connection, packet
    unpacked = deBetaPacket.bisect(packet.unpack("ClU*"))
    player_name = unpacked[3..19].pack("U*")
    @log.info("Login: #{player_name} has joined the server.")
    @log.debug("Selecting default world...")
    world_select = @server.worlds[0]
    @server.worlds.each do |world|
      if world.name == @config.default_world
        world_select = world
      end
    end
    @log.debug("Default world is #{world_select.name}")
    player = world_select.load_player(player_name, connection)
    payload = [@packets[:login_request]]
    @log.debug("Player ID: #{int(player.id)}")
    payload.concat BetaPacket.int(player.id)
    payload.concat BetaPacket.string16("test") #Unused
    payload.concat BetaPacket.long world_select.seed	#world seed
    payload.concat BetaPacket.int world_select.type		#server mode (1 for creative. 0 for survival)
    payload.concat BetaPacket.byte world_select.dimension		#dimention -1 for hell 0 for norm
    payload.concat BetaPacket.byte world_select.difficulty				#difficulty
    payload.concat [world_select.height]				#world_height
    max_players = @config.max_players
    if max_players > 60
      max_players = 60
    end
    payload.concat [max_players]					#Max players on server. More than 60 glitches
    @log.debug("Packet: #{payload}")
    @log.debug("BetaPacket.bisect: #{BetaPacket.bisect(payload)}")
    connection.send_data BetaPacket.bisect(payload).pack("C*")
    EventMachine::Timer.new(5.0) do
      @log.debug("pre_chunk timer!")
      send_pre_chunk connection, 0, 0, true
    end
    #TODO: Send Pre-Chunks
    EventMachine::Timer.new(10.0) do
      @log.debug("spawn_pos timer!")
      send_spawn_position connection, 0, 80, 0
    end
    #TODO: Send Inventory
    EventMachine::Timer.new(15.0) do
      @log.debug("player_pos timer!")
      send_player_position_look connection, 0.0,80.0,0.0,0.0,0.0,false,67.24
    end
  end

  def send_pre_chunk connection, x, z, mode
    payload = [@packets[:spawn_position]]
    payload.concat BetaPacket.int(x) #X, Y, Z
    payload.concat BetaPacket.int(z) #X, Y, Z
    payload.concat BetaPacket.bool(mode) #X, Y, Z
    send_payload connection, payload
  end

  def send_spawn_position connection, x, y, z
    payload = [@packets[:spawn_position]]
    payload.concat BetaPacket.int(0) #X, Y, Z
    payload.concat BetaPacket.int(80) #X, Y, Z
    payload.concat BetaPAcket.int(0) #X, Y, Z
    send_payload connection, payload
  end

  def send_player_position_look connection, x, y, z, yaw, pitch, on_ground, stance
    payload = [@packets[:player_position_look]]
    payload.concat BetaPacket.double x
    payload.concat BetaPacket.double stance
    payload.concat BetaPacket.double y
    payload.concat BetaPacket.double z
    payload.concat BetaPaccket.float yaw
    payload.concat BetaPacket.float pitch
    payload.concat BetaPacket.bool on_ground
    send_payload connection, payload
  end

  def send_payload connection, payload
    connection.send_data BetaPacket.bisect(payload).pack("C*")
  end

  def keep_alive connection
    @last_keep_alive = rand(0..32767)
    payload = [@packets[:keep_alive]]
    payload.concat BetaPacket.int @last_keep_alive
    connection.send_data BetaPacket.bisect(payload).pack("C*")
  end

  def check_keep_alive connection, packet
    #TODO: Implement time outs. (Low priority)
  end

  def server_list_ping connection, packet
    @log.debug "Got ping connection"
    #Always returns 0 players online.
    message = BetaPacket.utfize(@config.description) + @delim + BetaPacket.utfize(@server.players.size.to_s) + @delim + BetaPacket.utfize(@config.max_players.to_s)
    payload =  [@packets[:server_kick]]
    payload.concat(BetaPacket.string16 message)
    connection.send_data (payload).pack("S_C*")
  end

  def send_kick connection, reason
    @log.info("Kicking: #{connection.player.name}, Reason: #{reason}")
    payload =  [@packets[:server_kick]]
    payload.concat(BetaPacket.string16 reason)
    connection.send_data BetaPacket.bisect(payload).pack("C*")
  end
end
