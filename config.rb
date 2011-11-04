# This class provides configuration variables for the entire server. At a later date, it will be superseded
# with a more dynamic configuration-backend loading scheme.
# == Authors    
# * Tanner Danzey (mailto:arkaniad@gmail.com) 
# * Tristan Rice (mailto:rice@outerearth.net)  
# == License   
# Distributes under the same terms as Ruby
# == Variables
# * _interface_ = the interface that the server will listen to. 0.0.0.0 listens on every interface, which is default.
# * _port_ = port that the server will listen on. Default should be 25565, which is standard.
# * _maxplayers_ = maximum amount of players allowed on the server at a time.
# * _description_ = description that will be shown in the server list on supporting clients.
# * _motd_ = message displayed to clients upon connection. empty strings will be treated as no message at all.
# * _minversion_ = not used yet, can be anything.
# * _maxversion_ = not used yet, can be anything.
# * _authenticate_ = whether the server should authenticate clients with minecraft.net.
# == Example
# * _minversion_ = not used yet, can be anything. May never be used (most likely).
# * _maxversion_ = not used yet, can be anything. May never be used (most likely).
# * _protocols_ = an array of protocol handlers. Currently the only one is: BetaProtocol
# * _worlds_ = an array of WorldConfig elements. WorldConfig.new( <String, World Name>, <seed>, [<Terrain Generators>])
# == Examples
#
# 
#   @interface = "0.0.0.0"
#   @port = 25565
#   @maxplayers = 24
#   @description = "Tanner's Server O' fun!"
#   @motd = "Welcome to Tanner's Server O' fun! Enjoy yourself!"
#   @minversion = 0
#   @maxversion = 10000
#   @protocols = [BetaProtocol]
#   @authenticate = true
#	@worlds = []
#	@worlds.push WorldConfig.new( "boring_world1", 15, [FlatgrassGenerator] )
class Configuration
  attr_accessor :interface, :port, :max_players, :description, :motd, :minversion, :maxversion, :protocols, :authenticate, :worlds, :default_world, :log_level
  def initialize
    @interface = "0.0.0.0"
    @port = 25565
    @max_players = -1
    @description = "RubyCraft Test Server!"
    @motd = "Welcome to the server!"
    @minversion = 0
    @maxversion = 9001
    @protocols = [BetaProtocol]
    @authenticate = false
    @default_world = "world1"
    @worlds = []
    @worlds.push WorldConfig.new( "world1", 15, [FlatgrassGenerator] )
    @log_level = Logger::DEBUG
  end
end

require(File.join(File.dirname(__FILE__), "lib/config_utils.rb"))
