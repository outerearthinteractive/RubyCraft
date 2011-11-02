
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
		@log = server.log
		@server = server
		@config = server.config
		init_packets()
		@log.info("BetaProtocol Enabled!")
		@log.info @packets[:server_list_ping]
	end
	def read_packet connection, packet, players
	  @players = players
		packet_id = packet[0,1].unpack("C")[0]
		@log.debug("Packet Id: #{packet_id}")
		#puts "Received Packet: "+@packets.key(packet_id).to_s
		case packet_id
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
	  	@log.info("Handshake from player: #{packet.chomp}")
		@log.info("Adding player to active list.")
		@players += {packet.chomp => Player.new(packet.chomp)}
	  	payload =  [@packets[:handshake]]
		payload.concat(string16 "-")
		connection.send_data bisect(payload).pack("C*")
	end
	def login_request connection, packet
	  @log.debug packet
	end
	def keep_alive connection
	  	@last_keep_alive = rand(32767..65536)
	  	payload = [@packet[:keep_alive],@last_keep_alive]
	  	connection.send_data bisect(payload).pack("C*")
	end
	def check_keep_alive connection, packet
	end
	def server_list_ping connection, packet
		@log.debug "Got ping connection"
		#Always returns 0 players online. 
		message = utfize(@config.description) + @delim + utfize(@server.players.length.to_s) + @delim + utfize(@config.max_players.to_s)
		payload =  [@packets[:server_kick]]
		payload.concat(string16 message)
		connection.send_data bisect(payload).pack("C*")
	end
	
	def send_kick connection, reason
	  	@log.info("Kicking: #{connection.player.name}, Reason: #{reason}")
	  	payload =  [@packets[:server_kick]]
		payload.concat(string16 reason)
		connection.send_data bisect(payload).pack("C*")
	end
	
	def string16 message
		payload = [message.size]
		payload.concat(bytize(message))
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
end
