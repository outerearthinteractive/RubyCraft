Dir.glob(File.dirname(__FILE__) + '/protocol/*.rb') {|file| require file}

class ProtocolHandler
	def initialize server
		@server = server
		@config = server.config
		@protocols = []
		@config.protocols.each do |proto|
			@protocols += [(proto.new @server)]
		end
	end
	def read_packet connection, packet, players
		@protocols.each do |p|
			p.read_packet connection, packet, players
		end
	end
end
