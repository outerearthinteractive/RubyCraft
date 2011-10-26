#!/usr/bin/env ruby
# This file runs everything.
Dir.glob(File.dirname(__FILE__) + '/lib/*.rb') {|file| require file}
require "rubygems"
require "eventmachine"

EventMachine::run {
	s = Server.new
	s.start
}
