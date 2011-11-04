#require("block.rb")

class Chunk
attr_accessor :blocks, :x, :z
	def initialize server, world, x, z
		@x = x
		@z = z
		@blocks = Array.new(16) {Array.new(128) {Array.new(16){Block.new(0)}}}
	end
	def marshal_dump
		[@x,@z,@blocks]
	end
	def marshal_load array
		@x, @z, @blocks = array
	end
end
