module FlatgrassGenerator
	def generate_chunk(chunk, seed, x, y)
		chunk.blocks.each do |block|
			if block.y < 64
				block.type = 2
			end
		end
	end
end
