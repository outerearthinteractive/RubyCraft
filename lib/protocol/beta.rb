
class BetaProtocol
	def init_packets
	@players
	@last_keep_alive = 0
	@delim = "\xA7".force_encoding("UTF-16")
	@packets = {
	  :keep_alive        => 0,
		:login_request 			=> 1,
		:handshake 				=> 2,
		:chat_message 			=> 3,
		:time_update 			=> 4,
		:entity_equip 			=> 5,
		:spawn_position 		=> 6,
		:use_entity 			=> 7,
		:update_health 			=> 8,
		:respawn 				=> 9,
		:player 				=> 10,
		:player_position 		=> 11,
		:player_look 			=> 12,
		:player_position_look 	=> 13,
		:player_dig 			=> 14,
		:player_place 			=> 15,
		:holding_change 		=> 16,
		:use_bed 				=> 17,
		:animation 				=> 18,
		:entity_action 			=> 19,
		:named_entity_spawn		=> 20,
		:pickup_spawn 			=> 21,
		:collect_item 			=> 22,
		:add_object				=> 23,
		:add_vehicle			=> 23,
		:mob_spawn				=> 24,
		:entity_painting		=> 25,
		:experience_orb			=> 26,
		:stance_update			=> 27,
		:entity_velocity		=> 28,
		:destroy_entity			=> 29,
		:entity					=> 30,
		:entity_relative_move	=> 31,
		:entity_look			=> 32,
		:entity_look_relative_move => 33,
		:entity_teleport		=> 34,
		:entity_status			=> 38,
		:attach_entity			=> 39,
		:entity_metadata		=> 40,
		:entity_effect			=> 41,
		:entity_effect_remove 	=> 42,
		:experience				=> 43,
		:pre_chunk				=> 50,
		:map_chunk				=> 51,
		:block_change_multi		=> 52,
		:block_change			=> 53,
		:block_action			=> 54,
		:explosion				=> 60,
		:sound_effect			=> 61,
		:new_state				=> 70,
		:invalid_state			=> 70,
		:thunderbolt			=> 71,
		:window_open			=> 100,
		:window_close			=> 101,
		:window_click			=> 102,
		:window_set_slot		=> 103,
		:window_items			=> 104,
		:update_progress_bar	=> 105,
		:transaction			=> 106,
		:creative_inventory_action => 107,
		:update_sign			=> 130,
		:item_data				=> 131,
		:increment_statistic	=> 200,
		:player_list_item		=> 201,
		:server_list_ping		=> 254,
		:server_kick			=> 255 
	}
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
		payload.concat(string16 "-")
		connection.send_data bisect(payload).pack("C*")
	end
	def login_request connection, packet
		unpacked = debisect(packet.unpack("ClU*"))
		player = unpacked[3..19].pack("U*")
		@log.info("Login: #{player} has joined the server.")
		world_select = @server.worlds[0]
		@server.worlds.each do |world|
			if world.name == @config.default_world
				world_select = world
			end
		end
		world_select.load_player(player, connection)
		payload = [@packets[:login_request]]
		payload.concat int(player.id) #Ent id
		payload.concat string16("") #Unused
		payload.concat long world_select.seed	#world seed
		payload.concat int world_select.type		#server mode (1 for creative. 0 for survival)
		payload.concat byte world_select.dimention		#dimention -1 for hell 0 for norm
		payload.concat byte world_select.difficulty				#difficulty
		payload.concat [world_select.height]				#world_height
		max_players = @config.max_players
		if max_players > 60
			max_players = 60
		end
		payload.concat [max_players]					#Max players on server. More than 60 glitches
	  	connection.send_data bisect(payload).pack("C*")
	  	
	  	#TODO: Send Pre-Chunks
	  	EventMachine::Timer.new(0.2) do
	  		@log.debug("spawn_pos timer!")
	  		send_spawn_position connection, 0, 80, 0
	  	end
	  	#TODO: Send Inventory
	  	EventMachine::Timer.new(0.4) do
	  		@log.debug("player_pos timer!")
	  		send_player_position_look connection, 0.0,80.0,0.0,0.0,0.0,false,67.24
	  	end
	end
	def send_spawn_position connection, x, y, z
		payload = [@packets[:spawn_position]]
		payload.concat int(0) #X, Y, Z
		payload.concat int(80) #X, Y, Z
		payload.concat int(0) #X, Y, Z
		send_payload connection, payload
	end
	def send_player_position_look connection, x, y, z, yaw, pitch, on_ground, stance
		payload = [@packets[:player_position_look]]
		payload.concat double x 
		payload.concat double stance 
		payload.concat double y
		payload.concat double z
		payload.concat float yaw
		payload.concat float pitch
		payload.concat bool on_ground
		send_payload connection, payload
	end
	def send_payload connection, payload
		connection.send_data bisect(payload).pack("C*")
	end
	def keep_alive connection
	  	@last_keep_alive = rand(0..32767)
	  	payload = [@packets[:keep_alive]]
	  	payload.concat int @last_keep_alive
	  	connection.send_data bisect(payload).pack("C*")
	end
	def check_keep_alive connection, packet
		#TODO: Implement time outs. (Low priority)
	end
	def server_list_ping connection, packet
		@log.debug "Got ping connection"
		#Always returns 0 players online. 
		message = utfize(@config.description) + @delim + utfize(@server.players.length.to_s) + @delim + utfize(@config.max_players.to_s)
		send_kick connection, message
	end
	
	def send_kick connection, reason
	  	payload =  [@packets[:server_kick]]
		payload.concat(string16 reason)
		connection.send_data bisect(payload).pack("C*")
	end
	
	def string16 message
		payload = [message.size]
		payload.concat(bytize(message))
		return payload
	end
	def long message
		payload = [message].pack("q").unpack("C*")
		return payload
	end
	def double message
		payload = [message].pack("d").unpack("C*")
		return payload
	end
	def float message
		payload = [message].pack("f").unpack("C*")
		return payload
	end
	def bool message
		payload = 0
		if message==true
			payload = 1
		end
		return [payload]
	end
	def int message
		payload = [message].pack("l").unpack("C*")
		return payload
	end
	def byte message
		payload = [message].pack("c").unpack("C*")
		return payload
	end
	def bytize message
		message_bytes = []
		message.each_byte do 
			|b| message_bytes.push(b)
		end
		return message_bytes
	end
	def utfize string
		return string.force_encoding("UTF-16")
	end
	def bisect array #Epic hack to fake utf16
		buffer = []
		array.each { |item|
			buffer.push item
			buffer.push 0
		}
		buffer.pop
		return buffer
	end
	def debisect array
		buffer = []
		array.each do |item|
			if item != 0
				buffer.push item
			end
		end
		return buffer
	end
end
