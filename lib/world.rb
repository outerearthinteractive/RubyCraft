require "yaml"

class World
attr_accessor :config, :name, :players
@server
@name
@seed
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
