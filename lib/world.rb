class World
attr_accessor :config
@server
@name
@seed
@loaded_chunks
@players
	def initialize server, world_name, world_seed, world_config
		if File.exists?("../world/#{world_name}/")
			
		end
		@server = server
		@name = world_name
		@seed = world_seed
		@config = world_config
	end
end
