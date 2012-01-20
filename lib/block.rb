# This class provides configuration variables for the entire server. At a later date, it will be superseded
# with a more dynamic configuration-backend loading scheme.
# Distributes under the same terms as Ruby
# == Variables
# * _block_x_ = the x position of the block
# * _block_y_ = the y position of the block
# * _block_z_ = the z position of the block
# * _block_type_ = the item id of the block
# * _block_data_ = the extra data for the block
# == Example
# Create a block of wood at <120,64,159>
#   b = Block.new(120,64,159,5)
#
#
#

class Block
	attr_accessor :type, :data
	def initialize type
		@type = type
	end
end
