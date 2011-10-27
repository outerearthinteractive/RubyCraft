require 'eventmachine'
class Connection < EventMachine::Connection
	@log
	def initialize log server
		@log = log
		@server = server
	end
	def post_init
	  	@log.info "Client connected!"
	end
	def receive_data data
		
		if data =~ /quit/i then
			send_data ">>> goodbye"
			close_connection true
		else
	 		send_data ">>> you sent: #{data}"
		end
	end
	def unbind
		@log.info "Client disconnected."
	end
end
