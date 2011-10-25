# Base class for EVERYTHING.

class Server
	@lib_path
	@plugin_path
	def initialize()	
		@lib_path = File.join(File.dirname(__FILE__), "lib")
		@lib_path = File.join(File.dirname(__FILE__), "plugins")
		puts "Rubycraft initializing..."
	end
end

