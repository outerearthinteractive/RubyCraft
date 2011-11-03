require "yaml"

class World
attr_accessor :config, :name, :players, :seed
@server
@loaded_chunks
	def initialize server, world_config
		@server = server
		@name = world_config.name
		@seed = world_config.seed
		@config = world_config
		@players = {}
		if !File.exists?(File.join(File.dirname(__FILE__),"../world/#{@name}"))
			Dir.mkdir(File.join(File.dirname(__FILE__),"../world/#{@name}/"))
			Dir.mkdir(File.join(File.dirname(__FILE__),"../world/#{@name}/chunk/"))
			Dir.mkdir(File.join(File.dirname(__FILE__),"../world/#{@name}/player/"))
		end
		@server.log.info("Loaded world: #{@name}")
	end
	def save_player name
		player_file = File.join(File.dirname(__FILE__),"../world/#{@name}/player/#{name}.yml")
		File.open(player_file, "w") do |file|
			file.puts YAML::dump(@players[name])
		end
	end
	def remove_player name
		@players[name].delete
	end
	def load_player name, connection
		player_file = File.join(File.dirname(__FILE__),"../world/#{@name}/player/#{name}.yml")
		if File.exists?(player_file)
			File.open(player_file, "r").each do |object|
				player = YAML::load(object)
			end
		else
			player = Player.new(name)
		end
		player.connection = connection
		@players[name]=player
	end
end
