module RCNetworkServer
	def post_init
	  puts "-- someone connected to the echo server!"
	end
	def receive_data data
	  send_data ">>> you sent: #{data}"
	end
end
