# Base class for EVERYTHING.
require(File.join(File.dirname(__FILE__), "logging.rb"))
class Server
	@plugins
	@lib_path
	@plugin_path
	def initialize()	
		@lib_path = File.dirname(__FILE__) + '/../lib/*.rb'
		@plugin_path = File.dirname(__FILE__) + '/../plugins/*.rb'
		@log = RubycraftLogger.new("RubyCraft")
		@log.log.info("Initialized")
		self.loadPlugins()
	end
	def loadPlugins()
		@log.log.info "Attempting to load plugins from #{@plugin_path}"
		Dir[@plugin_path].each {|file| @log.log.debug("Plugin found in #{file}")
			require file
		}
		@plugins = {'ConfigPlugin' => Plugin::ConfigPlugin.new}	
	end
end

