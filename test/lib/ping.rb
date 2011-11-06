class Ping < ProtocolTest
  @@delim = "\xA7".force_encoding("UTF-16")
  @@ping = "\xFE".force_encoding("UTF-16")
  def initialize socket, log, test="PingTest", *args
    super
  end

  def test
    data = ""
    data_array = ""
    data_packet = ""
    data_length = 0
    data_description = ""
    data_players = 0
    data_maxplayers = 0

    @socket.send @@ping, 0
    line = @socket.recv(255)
    @log.info("Received response. Decoding.")
    data = line
    data_array = data.unpack("SC*")
    @log.info("Packet type: #{data_array[0]}")
    @log.info("Kick packet? #{data_array[0]==255}")
    @log.info("Message length: #{data_array[1,2].pack("S_").unpack("C*")[0]}")
    @log.info("Received: #{data}")
    @log.info("As Array: #{data_array}")

  end
end