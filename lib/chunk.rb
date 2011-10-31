#require("block.rb")

class Chunk
attr_accessor :blocks, :x, :z
@server
@world
@x
@z
@cblocks
	def initialize server, world, x, z
		@server = server
		@world = world
		@x = x
		@z = z
		@blocks = []
		x = 0
		16.times do
			z=0
			16.times do
				y=0
				128.times do
					@blocks += [Block.new(x,y,z,0)]
					y+=1
				end
				z+=1
			end
			x+=1
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
