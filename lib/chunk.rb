#require("block.rb")

class Chunk
attr_accessor :blocks, :x, :z
@server
@world
	def initialize server, world, x, z
		@server = server
		@world = world
		@x = x
		@z = z
		@blocks = Array.new(16) {Array.new(128) {Array.new(16){Block.new(0)}}}
	end
	def save
	end
end
