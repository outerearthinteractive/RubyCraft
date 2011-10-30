require 'eventmachine'
require(File.join(File.dirname(__FILE__), "logging.rb"))

class Connection < EventMachine::Connection
	attr_accessor :server, :log, :player
	@player
	@server
	@log
	def initialize
	end
	def post_init
		#@log = @server.log
	  	#@log.info "Client connected!"
	end
	def receive_data data
		@server.protocol.read_packet self, data, @player
	end
	def unbind
		@log.info "Client disconnected."
	end
end
