#require("block.rb")

class Chunk
@server
@world
@chunk_x
@chunk_y
@chunk_blocks
	def initialize server, world, x, z
		@server = server
		@world = world
		@chunk_blocks = []
		x = 0
		16.times do
			z=0
			16.times do
				y=0
				128.times do
					@chunk_blocks += [Block.new(x,y,z,0)]
				end
			end
		end
	end
	def get_block_at x, y, z
		@chunk_blocks.each do |block|
			if block.x == x and block.y == y and block.z == z
				return block
			end
		end
		return nil
	end
	def save
	end
end
