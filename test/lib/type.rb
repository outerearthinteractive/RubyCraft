class Type < ProtocolTest
  def initialize socket, log, test="TypeTest", *args
    super
  end

  def test
    test_bools
    test_shorts
    test_strings
  end

  def test_bools
    @log.info "Testing true & false booleans"
    @log.debug BetaPacket.bool(true)
    @log.debug BetaPacket.bool(false)
  end

  def test_shorts
    @log.info "Testing shorts (lol)"
    numbers = [0, 1, 2, 100, 200, 240, -1, -2, 32767, 32768]
    numbers.each do |n|
      n_temp = BetaPacket.short(n)
      n_temp_real = n_temp.pack("C*").unpack("S_")
      @log.debug "n,n_temp: (#{n}, #{n_temp[0]})"
      @log.debug "n == n_temp? #{n==n_temp_real[0]} (n_temp_real = #{n_temp_real})"
    end

    def test_strings
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
      b_arr = BetaPacket.bisect(string.unpack("C*"))
      arr_s = arr.pack("C*")
      b_arr_s = b_arr.pack("C*")
      @log.debug "Encoding: #{enc}"
      @log.debug "Byte Array: #{arr}"
      @log.debug "Bisected Array: #{b_arr}"
      @log.debug "Byte Array Packed: #{arr_s}"
      @log.debug "Bisected Array Packed: #{b_arr_s}"
      @log.debug "Byte Array Encoding: #{arr_s.encoding}"
      @log.debug "Bisected Array Encoding: #{b_arr_s.encoding}"
      test_properly_mc_encoded string, BetaPacket.string16(string)
      @log.debug "==============================================================="
    end

    def test_properly_mc_encoded orig, result
      @log.debug "= Testing for two-way length compatibility                    ="
      @log.debug "Length of original: #{orig.size}"
      @log.debug "Length of converted: #{BetaPacket.string16len(result)}"
      @log.debug "Equal length? #{orig.size == BetaPacket.string16len(result)}"
      @log.debug "= Testing for two-way content compatibility                   ="
      @log.debug "Original: #{orig.encode("UTF-8")}"
      @log.debug "New: #{result[2..(orig.size)].pack("c*")}"
      @log.debug "New in Array form: #{result[2,(orig.size)]}"
    end
  end
end