Dir.glob(File.dirname(__FILE__) + '/protocol/*.rb') {|file| require file}

class ProtocolHandeler
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
