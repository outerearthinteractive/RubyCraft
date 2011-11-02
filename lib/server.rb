# Base class for EVERYTHING.
require(File.join(File.dirname(__FILE__), "logging.rb"))
require(File.join(File.dirname(__FILE__), "network.rb"))
require(File.join(File.dirname(__FILE__), "command.rb"))
require(File.join(File.dirname(__FILE__), "terrain_generators.rb"))
require(File.join(File.dirname(__FILE__), "../config.rb"))
require 'rubygems'
require 'eventmachine'
require(File.join(File.dirname(__FILE__), "protocol.rb"))
class Server
	attr_accessor :connections, :protocol, :log, :players, :worlds
	@plugins
	@lib_path
	@plugin_path
	@configuration
	def initialize
		@log = RubycraftLogger.new("RubyCraft")
		@log.info("Initialized")
		@configuration = Configuration.new
		@connections = []
		@protocol = ProtocolHandler.new self
		@players = {}
		if @configuration.max_players == -1
			@configuration.max_players = 65536
		end
		worlds=[]
		@configuration.worlds.each do |world|
			worlds.push World.new(self,world)
		end
	end
	def config
		return @configuration
	end
	def start
		@server = EventMachine::start_server @configuration.interface, @configuration.port, Connection do |con|
			con.server = self
			con.log = @log
			#con.players = @players
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
end
