#!/usr/bin/env ruby

#$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'lib' ) )
$LOAD_PATH.unshift( File.dirname(__FILE__) )

# This file includes everything, and then runs the server.
# Every class that is added should be required here and not elsewhere.

require 'logger'
require "yaml"
require "zlib"
require 'rubygems'
require 'eventmachine'
require 'lib/server'
require 'lib/logging'
require 'lib/multio'
require 'lib/block'
require 'lib/world'
require 'lib/player'
require 'lib/chunk'
require 'lib/protocol'
require 'lib/network'
require 'lib/command'
require 'lib/terrain_generators'
require 'lib/inventory'
require 'config'
require 'lib/config_utils'

# Dynamically Loaded Classes
Dir.glob(File.dirname(__FILE__) + '/lib/protocol/*.rb') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/lib/protocol/*/*.rb') {|file| require file}
Dir.glob(File.dirname(__FILE__) + '/lib/generator/*.rb') {|file| require file}

EventMachine::run {
	s = Server.new
	s.start
}
