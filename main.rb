#!/usr/bin/env ruby

# This file runs everything.

require 'rubygems'
require 'eventmachine'


Dir.glob(File.dirname(__FILE__) + '/lib/*.rb') {|file| require file}


EventMachine::run {
	s = Server.new
	s.start
}
