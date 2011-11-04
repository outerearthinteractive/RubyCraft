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
__ruby 1.9.3-p0__ - Linux (RVM recommended! __rvmsudo rvm install 1.9.3-p0; rvmsudo rvm use 1.9.3-p0 --default__)
	gems:	
	__eventmachine__ - (_rvmsudo rvm gem install eventmachine_)
