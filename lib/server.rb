# Base class for EVERYTHING.
require(File.join(File.dirname(__FILE__), "logging.rb"))
require(File.join(File.dirname(__FILE__), "network.rb"))
require(File.join(File.dirname(__FILE__), "command.rb"))
require(File.join(File.dirname(__FILE__), "../config.rb"))
require 'rubygems'
require 'eventmachine'
require(File.join(File.dirname(__FILE__), "protocol.rb"))
class Server
	attr_accessor :connections, :protocol, :log
	@plugins
	@lib_path
	@plugin_path
	@configuration
	def initialize
		@log = RubycraftLogger.new("RubyCraft")
		@log.info("Initialized")
		@configuration = Configuration.new
		@log.log.error("ERROR: Configuration is broken. Halting.") and stop unless self.verifyConfiguration @configuration
		@connections = []
		@protocol = Protocol.new @log, self
	end
	def config
		return @configuration
	end
	def start
		@server = EventMachine::start_server @configuration.interface, @configuration.port, Connection do |con|
			con.server = self
			con.log = @log
		end
		@console = EventMachine::open_keyboard(CommandHandler) do |con|
			con.server = self
		end
		@log.log.info "Server Listening, port #{@configuration.port}"
	end
	def stop
		@log.info "Stopping server..."
		EventMachine::stop_server(@server)
		exit 1
	end
	def verifyConfiguration c
	  #TODO: Verify more things.
		if c.port is_a? Integer and c.interface is_a? String
			return true
		else
			return false
		end
	end
end
