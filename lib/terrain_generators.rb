Dir.glob(File.join(File.dirname(__FILE__),'./generator/*.rb')) {|file| require file}

class GeneratorHandeler
	def initialize server
		@server = server
		@config_worlds = server.config.worlds
		@server.log.info("Terrain Generator enabled.")
	end
	def generate_chunk world, x, z
		chunk = Chunk.new @server, world, x, z
		generators = world.config.generators
		generators.each do |generator|
			generator::generate_chunk(chunk, world.seed, x, z)
		end
		return chunk
	end
end
