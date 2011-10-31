RubyCraft
=========

About
-----
RubyCraft is a Minecraft server written completely in the Ruby language and utilizing the EventMachine network library. At the present moment, it's incomplete, but you are welcome to hack upon it.

Configuration
-------------
All of the server settings lie in the file 'config.rb', which is right next to main.rb.

Running
-------

To start the server just run "ruby main.rb" in the root directory.

Alternatively, if you are using *nix, you can do this:
chmod +x main.rb
./main.rb

Required Software
-----------------
ruby 1.9 - Linux (sudo apt-get install ruby19, or use RVM. 1.9 is necessary!)
	gems:	
	eventmachine - (gem install eventmachine)
