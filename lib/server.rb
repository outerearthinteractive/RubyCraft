# Base class for EVERYTHING.
require(File.join(File.dirname(__FILE__), "logging.rb"))
require(File.join(File.dirname(__FILE__), "network.rb"))
require 'rubygems'
require 'eventmachine'

class Server
	@plugins
	@lib_path
	@plugin_path
	def initialize()	
		@lib_path = File.join(File.dirname(__FILE__), "lib")
		@plugin_path = File.join(File.dirname(__FILE__), "plugins")
		@log = RubycraftLogger.new("RubyCraft")
		@log.log.info("Initialized")
		self.startReactor
		self.loadPlugins()
	end
	def startReactor
		EventMachine::run {
			EventMachine::start_server "127.0.0.1", 25565, RCNetworkServer
			@log.log.info 'Server Listening, port 25565'
		}
	end
	def loadPlugins()
		@log.log.info "Attempting to load plugins from #{@plugin_path}"
		Dir.glob(@plugin_path) {|file| require file}
		@plugins = {'ConfigPlugin' => Plugin::ConfigPlugin.new}	
	end
end

