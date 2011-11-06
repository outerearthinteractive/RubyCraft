class ProtocolTest
  @socket
  @test
  @log
  def initialize socket, log, test = "BasicProtocolTest"
    @socket = socket
    @test = test
    @log = log
  end
  def test
    log.info "Running '#{@test}' on #{@socket.inspect}"
    raise NoTestBodyException.new("Test '#{@test}' is a stub. Try implementing some test methods.")
    return false;
  end
end