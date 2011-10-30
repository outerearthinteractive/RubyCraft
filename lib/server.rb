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
	@players
	def initialize
		@log = RubycraftLogger.new("RubyCraft")
		@log.info("Initialized")
		@configuration = Configuration.new
		@connections = []
		@protocol = ProtocolHandeler.new @log, self
		@players = []
	end
	def config
		return @configuration
	end
	def start
		@server = EventMachine::start_server @configuration.interface, @configuration.port, Connection do |con|
			con.server = self
			con.log = @log
			con.player = @players.push(Player.new)
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
