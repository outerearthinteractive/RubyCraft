class Type < ProtocolTest
  def initialize socket, log, test="TypeTest", *args
    super
  end
  def test
    @log.info "Testing true & false booleans"
    @log.debug Packet.bool(true)
    @log.debug Packet.bool(false)
    @log.info "Testing shorts (lol)"
    numbers = [0, 1, 2, 100, 200, 240, -1, -2, 32767, 32768]
    numbers.each do |n|
      n_temp = Packet.short(n)
      n_temp_real = n_temp.pack("C*").unpack("S_")
      @log.debug "n,n_temp: (#{n}, #{n_temp[0]})"
      @log.debug "n == n_temp? #{n==n_temp_real[0]} (n_temp_real = #{n_temp_real})"
    end
    @log.info "Testing strings"
    original = "Hello World!"
    @log.debug "==============================================================="
    @log.debug "= Original String: 'Hello World!'                             ="
    @log.debug "==============================================================="
    dump_info(original)
    dump_info(original.encode("UTF-8"))
    dump_info(original.encode("UTF-16"))
  end
  def dump_info string
    enc = string.encoding
    arr = string.unpack("C*")
    b_arr = Packet.bisect(string.unpack("C*"))
    arr_s = arr.pack("C*")
    b_arr_s = b_arr.pack("C*")
    @log.debug "Encoding: #{enc}"
    @log.debug "Byte Array: #{arr}"
    @log.debug "Bisected Array: #{b_arr}"
    @log.debug "Byte Array Packed: #{arr_s}"
    @log.debug "Bisected Array Packed: #{b_arr_s}"
    @log.debug "Byte Array Encoding: #{arr_s.encoding}"
    @log.debug "Bisected Array Encoding: #{b_arr_s.encoding}"
    @log.debug "==============================================================="
  end
  def test_properly_mc_encoded original, result
    
  end
end