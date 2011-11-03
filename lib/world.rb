require "yaml"

class World
attr_accessor :config, :name, :players, :seed, :height, :type, :dimension, :difficulty
@server
@loaded_chunks
	def initialize server, world_config
		@server = server
		@name = world_config.name
		@seed = world_config.seed
		@config = world_config
		@players = {}
		@height = 128
		@dimension = 0 #0 = Normal, -1 = Nether
		@type = 1 #1 = creative, 0 = survival
		@difficulty = 0
		if !File.exists?(File.join(File.dirname(__FILE__),"../world/#{@name}"))
			@server.log.info "Creating filespace for world: #{@name}"
			Dir.mkdir(File.join(File.dirname(__FILE__),"../world/#{@name}/"))
			Dir.mkdir(File.join(File.dirname(__FILE__),"../world/#{@name}/chunk/"))
			Dir.mkdir(File.join(File.dirname(__FILE__),"../world/#{@name}/player/"))
			load_chunk 0,0
		end
		@server.log.info("Loaded world: #{@name}")
	end
	def save_chunk x, z
		chunk_file = File.join(File.dirname(__FILE__),"../world/#{@name}/chunk/#{x},#{z}.yml")
		File.open(chunk_file, "w") do |file|
			file.puts Marshal::dump(get_chunk_at(x,z))
		end
	end
	def load_chunk x, z
		@server.log.info "Generating chunk #{x}, ?, #{z}. World: #{name}"
		chunk_file = File.join(File.dirname(__FILE__),"../world/#{@name}/chunk/#{x},#{z}.yml")
		if File.exists?(chunk_file)
			File.open(chunk_file, "r").each do |object|
				@loaded_chunks.push Marshal::load(object)
			end
		else
			@loaded_chunks.push @server.terrain_generator.generate_chunk(self,x,y)
		end
	end
	def get_chunk_at x, z
		@loaded_chunks.each do |block|
			if block.x == x and block.z == z
				return block
			end
		end
		return nil
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
