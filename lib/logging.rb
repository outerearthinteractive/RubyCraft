require 'logger'
class RubycraftLogger
	attr_accessor :log, :tag
	def initialize(tag)
		self.tag = tag
		f = File.open(File.join(File.dirname(__FILE__), "../log.txt"), "a+")
		self.log = Logger.new(
				MultiIO.new(STDOUT, f))
		log.level = Logger::DEBUG
		log.datetime_format = "%Y-%m-%d %H:%M:%S"
		log.formatter = proc { |severity, datetime, progname, msg|
			"[#{self.tag}] #{datetime}: #{msg}\n"
		}
		log.info("Logger initialized")
	end
end
