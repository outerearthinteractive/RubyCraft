class ProtocolHandler
	def initialize server
		@server = server
		@config = server.config
		@protocols = []
		@config.protocols.each do |proto|
			@protocols += [(proto.new @server)]
		end
	end
	def read_packet connection, packet
		@protocols.each do |p|
			p.read_packet connection, packet
		end
	end
end
