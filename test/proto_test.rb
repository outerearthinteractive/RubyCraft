$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'lib' ) )
require 'host'
require 'socket'
require 'packets'
require 'exceptions'
require 'test_base'
require 'ping'


results = []
routine_list = [Ping]
routine_hold = []
hosts = [Host.new("127.0.0.1", 25565), Host.new("outerearth.net", 25565)]
hosts.each do |host|
  begin
    sock = TCPSocket.new(host.host, host.port)
    begin
    routine_list.each {|routine|
      r = routine.new(sock)
      r.test
      r = nil
      }
    rescue NoTestBodyException => ex
      puts ex.message
    end
  rescue Errno::ECONNREFUSED
    puts "Connection refused for #{host.to_s}"
  else
    puts "No show-stopping errors for #{host.to_s}"
  ensure
    puts "Closing socket, just in case."
    sock.close unless sock.nil?
  end
end
puts Packets::list

