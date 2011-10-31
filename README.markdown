RubyCraft
=========

About
-----
RubyCraft is a Minecraft server written completely in the Ruby language and utilizing the EventMachine network library. At the present moment, it's incomplete, but you are welcome to hack upon it.

Configuration
-------------
All of the server settings lie in the file _config.rb_, which is right next to main.rb.

Running
-------

To start the server just run _ruby main.rb_ in the root directory.

Alternatively, if you are using Li/unix, you can do this:
_chmod +x main.rb_
_./main.rb_

Required Software
-----------------
__ruby 1.9__ - Linux (_sudo apt-get install ruby19_, or use RVM. 1.9 is necessary!)
	gems:	
	__eventmachine__ - (_gem install eventmachine_)
