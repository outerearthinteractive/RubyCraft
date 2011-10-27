class Configuration
	#This is a list of vars that can be accessed outside the class directly.
	#Pretty much everything in this file should be listed here.
	attr_accessor :ip, :port, :maxplayers, :motd, :maxversion, :minversion
	
	def initialize()
		#All the variables & there values should be set here.
		self.ip = "127.0.0.1"
		self.port = 25565
		self.maxplayers = 20
		self.motd = "Welcome to the server!"
		self.minversion = 0
		self.maxversion = 9001
	end
end
