
class RubycraftPlugin
	attr_accessor :name, :author, :version, :description
	def initialize(name = "MyPlugin", author="User", version="1.0", description="I forgot to change my stuff.", log)
		self.name = name
		self.author = author
		self.version = version
		self.description = description
		self.log = log
		log.info "Plugin #{self.name} #{self.version} initialized."	
	end
end
