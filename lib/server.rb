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
		@lib_path = File.dirname(__FILE__) + '/../lib/*.rb'
		@plugin_path = File.dirname(__FILE__) + '/../plugins/*.rb'
		@log = RubycraftLogger.new("RubyCraft")
		@log.info("Initialized")
		@configuration = Configuration.new
		@log.log.error("ERROR: Configuration is broken. Halting.") and stop unless self.verifyConfiguration @configuration
		self.loadPlugins
		@connections = []
		@protocol = Protocol.new @log, self
	end
	def config
		return @configuration
	end
	def start
		@server = EventMachine::start_server '0.0.0.0', @configuration.port, Connection do |con|
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
	def loadPlugins
		@log.log.info "Attempting to load plugins from #{@plugin_path}"
		#Dir.chdir("../") #Hacky.
		Dir.glob(@plugin_path) {|file| require file}
		#@plugins = {'ConfigPlugin' => ConfigPlugin.new}
	end
	def verifyConfiguration c
		#Todo: Add better verification. This will do for now.
		if c.port then
			return true
		else
			return false
		end
	end
end
