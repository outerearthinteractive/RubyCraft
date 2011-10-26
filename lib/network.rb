module NetworkServer
	def post_init
	  	puts "-- someone connected to the echo server!"
	end
	def receive_data data
		
		if data =~ /quit/i then
			send_data ">>> goodbye"
			close_connection
		else
	 		send_data ">>> you sent: #{data}"
		end
	end
end
