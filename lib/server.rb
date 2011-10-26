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
	def initialize()	
		@lib_path = File.dirname(__FILE__) + '/../lib/*.rb'
		@plugin_path = File.dirname(__FILE__) + '/../plugins/*.rb'
		@log = RubycraftLogger.new("RubyCraft")
		@log.log.info("Initialized")
		@configuration = Configuration.new
		self.loadPlugins
		@connections = []
	end
	def start
		EventMachine::start_server @configuration.ip, @configuration.port, RCNetworkServer
		@log.log.info "Server Listening, port #{@configuration.port}"
	end
	def stop
		EventMachine.stop_server(@signature)
	end
	def loadPlugins()
		@log.log.info "Attempting to load plugins from #{@plugin_path}"
		Dir.chdir("../") #Hacky.
		Dir.glob(File.dirname(__FILE__) + '/plugins/*.rb') {|file| require file}
		#@plugins = {'ConfigPlugin' => ConfigPlugin.new}	
	end
end

class Connection < EventMachine::Connection
	attr_accessor :server

	def unbind
		server.connections.delete(self)
	end
end

