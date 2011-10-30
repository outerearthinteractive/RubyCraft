
class WorldConfig
	attr_accessor :name, :seed, :generators
	def initialize name, seed, generators
		@name = name
		@seed = seed
		@generators = generators
		return [self]
	end
end
