module FlatgrassGenerator
	def FlatgrassGenerator::generate_chunk(chunk, seed, x, z)
		(0..15).each do |x|
			(0..63).each do |y|
				(0..15).each do |z|
					chunk.blocks[x][y][z].type = 2
				end
			end
		end
	end
end
