class Configuration

#This is a list of vars that can be accessed outside the class directly.
#Pretty much everything in this file should be listed here.
attr_accessor :port, :maxplayers, :motd, :maxversion, :minversion, :name, :protocols

def initialize()

#All the variables & there values should be set here.
#Port it should run on. This is the default for Minecraft BETA/SMP.
@port = 25565
# Number of people that can be on the server.
@maxplayers = 20
#Name of the server displayed on the minecraft server list!
@name = "RubyCraft Test Server!"
#Message of the day! Whoo Hoo!
@motd = "Welcome to the server!"

#This may not be the most effective way to limit protocol versions (Especially w/ multiple protocols).
@minversion = 0
@maxversion = 9001

#These are the protocol versions that should be used.
#Example: @protocols = [BetaProtocol]
@protocols = [BetaProtocol]


end
def load_classes
Dir.glob(File.join(File.dirname(__FILE__), './plugins/*.rb')) {|file| require file}
Dir.glob(File.join(File.dirname(__FILE__), './lib/protocol/*.rb')) {|file| require file}
end
end
