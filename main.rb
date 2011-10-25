# This file runs everything.
Dir.glob(File.dirname(__FILE__) + '/lib/*') {|file| require file}

SERVER = Server.new
