RubyCraft
=========

About
-----
RubyCraft is a Minecraft server written completely in the Ruby language and utilizing the EventMachine network library. At the present moment, it's incomplete, but you are welcome to hack upon it.

License
-------------
RubyCraft is licensed under __Attribution-NonCommercial-ShareAlike 3.0 Unported (CC BY-NC-SA 3.0)__.
Full license can be found here:

_http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode_

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
__ruby 1.9.3-p0__ - See below for how to install w/ RVM.

__eventmachine__ - See below for how to install w/ RVM.

Recomended Software
-----------------
__rvm__ - Not required but easy to use.

Install (Ubuntu 11.10):
_sudo apt-get install ruby-rvm_

To use RVM everytime you start bash you need to run:
_source /etc/profile_

To install ruby:
_rvmsudo rvm install 1.9.3-p0_

To install eventmachine:
_rvmsudo rvm gem install eventmachine_
