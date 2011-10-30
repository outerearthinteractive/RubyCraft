
class WorldConfig
	attr_accessor :name, :generators
	def initialize name, generators
		@name = name
		@generators = generators
		return [self]
	end
end
