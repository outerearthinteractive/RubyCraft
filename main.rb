#!/usr/bin/env ruby
$LOAD_PATH.unshift( File.join( File.dirname(__FILE__), 'lib' ) )
# This file runs everything.
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
require 'protocol/beta'
require 'network'
require 'command'
require 'terrain_generators'
require 'generator/flatgrass'
Dir.glob(File.dirname(__FILE__) + '/config.rb') {|file| require file}



EventMachine::run {
	s = Server.new
	s.start
}
