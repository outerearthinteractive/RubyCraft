class ProtocolTest
  @socket
  @test
  def initialize socket, test = "BasicProtocolTest"
    @socket = socket
    @test = test
  end
  def test
    puts "Running '#{@test}' on #{@socket.inspect}"
    raise NoTestBodyException.new("Test '#{@test}' is a stub. Try implementing some test methods.")
  end
end