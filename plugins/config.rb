require("../lib/plugin.rb")
class ConfigPlugin < Plugin
	attr_accessor :ip, :port, :maxplayers, :motd
	def initialize(name, author, version, description, ip, port, maxplayers, motd)
		super(name, author, version, description)
		self.ip = ip
		self.port = port
		self.maxplayers = maxplayers
		self.motd = motd
	end
end
