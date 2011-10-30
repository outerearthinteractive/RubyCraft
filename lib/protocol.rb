require(File.join(File.dirname(__FILE__), "./protocol/beta.rb"))

class Protocol
	def initialize log, server
		@log = log
		@server = server
		@config = server.config
		@protocols = []
		@config.protocols.each do |proto|
			@protocols += [(proto.new @log, @server)]
		end
	end
	def read_packet connection, packet, player
		@protocols.each do |p|
			p.read_packet connection, packet, player
		end
	end
end
