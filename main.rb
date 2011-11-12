#!/usr/bin/env ruby

$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'lib' ) )

# This file includes everything, and then runs the server.
# Every class that is added should be required here and not elsewhere.

require 'logger'
require "yaml"
require "zlib"
require 'rubygems'
require 'eventmachine'
require 'server'
require 'logging'
require 'multio'
require 'block'
require 'world'
require 'player'
require 'chunk'
require 'protocol'
require 'network'
require 'command'
require 'terrain_generators'
Dir.glob(File.dirname(__FILE__) + '/config.rb') {|file| require file}

# Dynamically Loaded Classes
Dir.glob(File.dirname(__FILE__) + '/lib/protocol/*.rb') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/lib/protocol/*/*.rb') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/lib/generator/*.rb') {|file| require file}

EventMachine::run {
	s = Server.new
	s.start
}
