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
	def initialize()	
		@lib_path = File.dirname(__FILE__) + '/../lib/*.rb'
		@plugin_path = File.dirname(__FILE__) + '/../plugins/*.rb'
		@log = RubycraftLogger.new("RubyCraft")
		@log.log.info("Initialized")
		self.loadPlugins
		self.startReactor
	end
	def startReactor
		EventMachine::run {
			EventMachine::start_server "127.0.0.1", 25565, RCNetworkServer
			@log.log.info 'Server Listening, port 25565'
		}
	end
	def loadPlugins()
		@log.log.info "Attempting to load plugins from #{@plugin_path}"
		Dir.chdir("../") #Hacky.
		Dir.glob(File.dirname(__FILE__) + '/plugins/*.rb') {|file| require file}
		@plugins = {'ConfigPlugin' => ConfigPlugin.new}	
	end
end

