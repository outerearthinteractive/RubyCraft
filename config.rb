require("./lib/plugin.rb")

module RCConfig
	def ip
		return "127.0.0.1"
	end
	def port
		return 25565
	end
	def maxplayers
		return 20
	end
	def motd
		return "Welcome to the server!"
	end
	def maxversion
		return 9000
	end
	def minversion
		return 0
	end 
end
