require("./lib/plugin.rb")

class Configuration
	attr_accessor :ip, :port, :maxplayers, :motd, :maxversion, :minversion
	
	def initialize()
		self.ip = "127.0.0.1"
		self.port = 25565
		self.maxplayers = 20
		self.motd = "Welcome to the server!"
		self.minversion = 0
		self.maxversion = 9001
	end
end
