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
  ##
  # :category: Internal Classes
  #
  # Class that handles multiple IO objects gracefully, allowing a Logger object
  # to service both the console and a file seamlessly.
  class MultiIO
    ##
    # Puts the given list of IO objects into this wrapper class for writing to.
    # :args: *targets, list of target IO objects
    def initialize(*targets)
       @targets = targets
    end
    ##
    # Calls write() method with the given arguments for each of the IO objects contained.
    # :args: *args, arguments for the write call
    def write(*args)
      @targets.each {|t| t.write(*args)}
    end
    ##
    # Calls the close() method for each of the IO objects contained.
    def close
      @targets.each(&:close)
    end
  end
  ##
  # This class handles the bootstrapping and initialization of the
  # RubyCraft environment.
  class Loader
    @log
    ##
    # Initializes the bootstrap environment.
    # :args: log, the given top-level Logger object.
    def initialize log
      @log = log
      @log.debug("Bootstrap environment set up. Waiting for init...")
    end
    ##
    # Loads all of the modules from the path defined as $EXT_PATH.
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
  ##
  # Class that enables semi-unified logging capabilities.
  class Log
    attr_accessor :log, :tag
    ##
    # Initializes the RubyCraft::Logger object.
    # :args: tag, the desired tag to be included with all output
    # :args: output, the IO object to be written to. Should be a RubyCraft::MultiIO object.
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
    ##
    # Outputs a message to the Logger with log level "Debug"
    # :args: msg, message to be written to log
    def debug msg
      self.log.debug msg
    end
    ##
    # Outputs a message to the Logger with log level "Warn"
    # :args: msg, message to be written to log
    def warn msg
      self.log.warn msg
    end
    ##
    # Outputs a message to the Logger with log level "Error"
    # :args: msg, message to be written to log
    def error msg
      self.log.error msg
    end
    ##
    # Outputs a message to the Logger with log level "Info"
    # :args: msg, message to be written to log
    def info msg
      self.log.info msg
    end
  end
end

# Run the server and finish bootstrapping

# A nice little top-level logger.
log = RubyCraft::Log.new($LOG_PREFIX, 
                    RubyCraft::MultiIO.new(STDOUT, File.open($LOG_NAME, "a+")))
# Run the bootstrap
RubyCraft::Loader.new(log).init

if(defined?(RubyCraft::Server) == "constant")
  EventMachine::run do
	  s = RubyCraft::Server.new
	  s.start
  end
else
  log.debug "Couldn't load server module. Exiting."
  exit
end
