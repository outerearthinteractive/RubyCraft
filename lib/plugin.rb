class RubycraftPlugin
	attr_accessor :name, :author, :version, :description
	def initialize(name = "MyPlugin", author="User", version="1.0", description="I forgot to change my stuff.")
		self.name = name
		self.author = author
		self.version = version
		self.description = description
		puts "Plugin #{self.name} #{self.version} initialized."	
	end
end
