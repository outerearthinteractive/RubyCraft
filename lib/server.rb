# Base class for EVERYTHING.
require(File.join(File.dirname(__FILE__), "logging.rb"))
class Server
	@lib_path
	@plugin_path
	def initialize()	
		@lib_path = File.join(File.dirname(__FILE__), "lib")
		@plugin_path = File.join(File.dirname(__FILE__), "plugins")
		@log = RubycraftLogger.new("RubyCraft")
		@log.log.info("Initialized")
		self.loadPlugins()
	end
	def loadPlugins()
		@log.log.info "Attempting to load plugins from #{@plugin_path}"
		Dir.glob(@plugin_path) {|file| require file}
	end
end

