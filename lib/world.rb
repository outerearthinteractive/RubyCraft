require "yaml"

class World
attr_accessor :config, :name, :players
@server
@name
@seed
@loaded_chunks
	def initialize server, world_name, world_seed, world_config
		if !File.exists?("../world/#{world_name}")
			File.new("../world/#{world_name}/")
			File.new("../world/#{world_name}/chunk/")
			File.new("../world/#{world_name}/player/")
		end
		@server = server
		@name = world_name
		@seed = world_seed
		@config = world_config
		@players = {}
	end
	def save_player name
		File.open("../world/#{@name}/player/#{name}.yml", "w") do |file|
			file.puts YAML::dump(@players[name])
		end
	end
	def remove_player name
		@players[name].delete
	end
	def load_player name, connection
		if File.exists?("../world/#{@name}/player/#{name}.yml")
			File.open("../world/#{@name}/player/#{name}.yml", "r").each do |object|
				player = YAML::load(object)
			end
		else
			player = Player.new(name)
		end
		player.connection = connection
		@players[name]=player
	end
end
