$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'lib' ) )
require 'host'
require 'socket'
require 'packets'
require 'exceptions'
require 'test_base'
require 'ping'
require 'logger'
require 'type'

# Logger Initialization
tag = "RC Test"
log = Logger.new($stdout)
log.level = Logger::DEBUG
log.datetime_format = "%Y-%m-%d %H:%M:%S"
log.formatter = proc { |severity, datetime, progname, msg|
  datetime = datetime.strftime("%Y-%m-%d %H:%M:%S")
  "[#{tag}:#{severity}] #{datetime}: #{msg}\n"
}
log.info("Logger initialized")
# =====================

results = []
routine_list = [Ping, Type]
routine_hold = []
hosts = [Host.new("127.0.0.1", 25565), Host.new("outerearth.net", 25565)]
hosts.each do |host|
  begin
    sock = TCPSocket.new(host.host, host.port)
    log.info ("Running tests against #{host.to_s}")
    begin
      routine_list.each {|routine|
        r = routine.new(sock, log)
        r.test
        r = nil
      }
    rescue NoTestBodyException => ex
      log.warn ex.message
    end
  rescue Errno::ECONNREFUSED
    log.error "Connection refused for #{host.to_s}"
  else
    log.info "No show-stopping errors for #{host.to_s}"
  ensure
    log.debug "Closing socket, just in case."
    sock.close unless sock.nil?
  end
end


