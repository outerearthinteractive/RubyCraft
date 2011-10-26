# Base class for EVERYTHING.
require(File.join(File.dirname(__FILE__), "logging.rb"))
require(File.join(File.dirname(__FILE__), "network.rb"))
require(File.join(File.dirname(__FILE__), "../config.rb"))
require 'rubygems'
require 'eventmachine'

class Server
	@plugins
	@lib_path
	@plugin_path
	@configuration
	def initialize
		@lib_path = File.dirname(__FILE__) + '/../lib/*.rb'
		@plugin_path = File.dirname(__FILE__) + '/../plugins/*.rb'
		@log = RubycraftLogger.new("RubyCraft")
		@log.log.info("Initialized")
		@configuration = Configuration.new
		@log.log.error("ERROR: Configuration is broken. Halting.") and exit 1 unless self.verifyConfiguration @configuration
		self.loadPlugins
		@connections = []
	end
	def start
		EventMachine::start_server @configuration.ip, @configuration.port, NetworkServer
		@log.log.info "Server Listening, port #{@configuration.port}"
	end
	def stop
		EventMachine.stop_server(@signature)
	end
	def loadPlugins
		@log.log.info "Attempting to load plugins from #{@plugin_path}"
		Dir.chdir("../") #Hacky.
		Dir.glob(File.dirname(__FILE__) + '/plugins/*.rb') {|file| require file}
		#@plugins = {'ConfigPlugin' => ConfigPlugin.new}	
	end
	def verifyConfiguration c
		#Todo: Add better verification. This will do for now.
		if c.ip and c.port then
			return true
		else
			return false
		end
	end
end

class Connection < EventMachine::Connection
	attr_accessor :server

	def unbind
		server.connections.delete(self)
	end
end

