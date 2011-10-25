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
		@lib_path = File.dirname(__FILE__) + '/../lib/*.rb'
		@plugin_path = File.dirname(__FILE__) + '/../plugins/*.rb'
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
		Dir[@plugin_path].each {|file| @log.log.debug("Plugin found in #{file}")
			require file
		}
		@plugins = {'ConfigPlugin' => Plugin::ConfigPlugin.new}	
	end
end

