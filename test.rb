require 'socket'

host = "127.0.0.1"
refe = "outerearth.net"
port = 25565

s = TCPSocket.open(host, port)
s.puts "\xFE".force_encoding("UTF-16")
b = s.recv(256)# Read lines from the socket
puts b     # And print with platform line terminator
arr1 = b.unpack("C*")
s.close               # Close the socket when done

s = TCPSocket.open(refe, port)
s.puts "\xFE".force_encoding("UTF-16")
b = s.recv(256)# Read lines from the socket
puts b     # And print with platform line terminator
arr2 = b.unpack("C*")
s.close               # Close the socket when done

puts arr1 == arr2
puts arr1.inspect
puts arr2.inspect

f = File.open("results.res", "a+")
f.puts arr1.pack("C*")
f.puts arr1.inspect
f.puts arr2.inspect
f.puts arr2.pack("C*")
f.close
