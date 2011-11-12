# Base class for EVERYTHING.

class Server
	attr_accessor :version, :connections, :protocol, :log, :players, :worlds, :terrain_generator
	@plugins
	@lib_path
	@plugin_path
	@configuration
	def initialize
		@version = "v0.1-alpha"
		@log = RubycraftLogger.new("RubyCraft")
		@log.info("RubyCraft #{@version}. Initializing...")
		if !File.exists?(File.join(File.dirname(__FILE__),"../world"))
			@log.info "Creating non-existant world directory."
			Dir.mkdir(File.join(File.dirname(__FILE__),"../world"))
		end
		@configuration = Configuration.new self
		if @configuration.max_players == -1
			@configuration.max_players = 2147483647
		end
		@log.log.level = @configuration.log_level
		@connections = []
		@protocol = ProtocolHandler.new self
		@players = {}
		@terrain_generator = GeneratorHandeler.new(self)
		@worlds=[]
		@configuration.worlds.each do |world|
			@worlds<< World.new(self,world)
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
		@worlds.each do |world|
			world.save_all
		end
		EventMachine::stop_server(@server)
		exit 1
	end
end
