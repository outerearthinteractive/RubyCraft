class Ping < ProtocolTest
  @delim = "\xA7".force_encoding("UTF-16")
  def initialize socket, log, test="PingTest", *args
    super
  end
  def test
    @log.debug @delim
    return true;
  end
end