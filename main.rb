#!/usr/bin/env ruby

# Initial includes for basic functionality.
require "logger"
require "rubygems"
require "yaml"
require "zlib"
require "eventmachine"

# Some global variables to setup the initial environment
# These are variables that don't need to be changed. For runtime configuration,
# Use the RubyCraft::Config class.

# Path where modules will be loaded from
$EXT_PATH = "lib/"
# File extension of modules (best leave this be)
$EXT = "*.rb"
# Name of the server's log file.
$LOG_NAME = "server.log"
# Prefix that will be included with the logs and in console.
$LOG_PREFIX = "[RubyCraft]"
##
# This module is the default container for all things RubyCraft.
#
module RubyCraft
  class MultiIO
    def initialize(*targets)
       @targets = targets
    end
    def write(*args)
      @targets.each {|t| t.write(*args)}
    end
    def close
      @targets.each(&:close)
    end
  end
  class Loader
    @log
    def initialize log
      @log = log
      @log.debug("Bootstrap environment set up. Waiting for init...")
    end
    def init
      blob = Dir.glob(File.join(File.dirname(__FILE__), "#{$EXT_PATH+$EXT}"))
      files = blob.length
      file_current = 1
      blob.each do |file|
        @log.debug "Loading file #{file_current}/#{files}\
         (#{((file_current.to_f / files.to_f) * 100.0).ceil}%)"
        require file
        file_current = file_current + 1
      end
    end
  end
  class Log
    attr_accessor :log, :tag
    def initialize tag, output
      self.tag = tag
      self.log = Logger.new(output)
      log.level = Logger::DEBUG
      fmt = "%Y-%m-%d %H:%M:%S"
      log.datetime_format = fmt
      log.formatter = proc do |severity, datetime, progname, msg|
        datetime = datetime.strftime(fmt)
        "[#{self.tag}:#{severity}@#{datetime}] #{msg}\n"
      end    
    end
    def debug msg
      self.log.debug msg
    endg
    def warn msg
      self.log.warn msg
    end
    def error msg
      self.log.error msg
    end
    def info msg
      self.log.info msg
    end
  end
end


# A nice little top-level logger.
log = RubyCraft::Log.new($LOG_PREFIX, 
                    RubyCraft::MultiIO.new(STDOUT, File.open($LOG_NAME, "a+")))
# Run the bootstrap
RubyCraft::Loader.new(log).init

# Check if the Server class was properly loaded. Die if it isn't.
if(defined?(RubyCraft::Server) == "constant") then
  cfg = nil
  if(defined?(RubyCraft::YAMLConfig) == "constant") then
    log.debug "YAMLConfig module found. Using that."
    cfg = RubyCraft::YAMLConfig.new
  else
    log.debug "No other configuration methods found. Defaulting to DefaultConfig."
    cfg = RubyCraft::DefaultConfig.new
  end
  EventMachine::run do
	  s = RubyCraft::Server.new(log)
	  s.start
  end
else
  log.debug "Couldn't load server module. Exiting."
  exit
end
