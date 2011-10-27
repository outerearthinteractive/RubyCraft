require(File.join(File.dirname(__FILE__), "./protocol/beta.rb"))

class Protocol
	def initialize log, server
		@log = log
		@server = server
		@betaprotocol = BetaProtocol.new @log, @server
	end
	def read_packet connection, packet
		@betaprotocol.read_packet connection, packet
	end
end
