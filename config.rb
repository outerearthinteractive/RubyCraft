class Configuration
	#This is a list of vars that can be accessed outside the class directly.
	#Pretty much everything in this file should be listed here.
	attr_accessor :ip, :port, :maxplayers, :motd, :maxversion, :minversion
	
	def initialize()
		#All the variables & there values should be set here.
		#Port it should run on. This is the default for Minecraft BETA/SMP.
		self.port = 25565
		# Number of people that can be on the server.
		self.maxplayers = 20
		#Message of the day! Whoo Hoo!
		self.motd = "Welcome to the server!"
		
		#This may not be the most effective way to limit protocol versions (Especially w/ multiple protocols).
		self.minversion = 0
		self.maxversion = 9001
	end
end
