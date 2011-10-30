class World
@server
@name
@seed
@loaded_chunks
@players
	def initialize server, world_name, world_seed
		@server = server
		@name = world_name
		@seed = world_seed
	end
end
