---
layout: post
title: Reading and writing files with Ruby
tags: [en-us, ruby, io]
---

I use Ruby to automate a good amount of daily tasks. They all involve manipulating files in some way: writing logs, creating testbenches for VHDL and some exercises from [Code Jam](http://code.google.com/codejam/), to cite a few.

In this post, I'm going to describe how to do basic file I/O in Ruby, for it *is* useful and actually necessary even for basic scripting tasks. Let's start.

# The File and the IO classes

The File class is used to access the filesystem, e.g. create a file, write to it, read it. It inherits some cool methods from the IO class, like [#readlines](http://www.ruby-doc.org/core-1.9.3/IO.html#method-c-readlines).

What you'll probably use the most is File#open, which accepts a parameter to specify the operation and a block. One very cool thing is that if you use a block to handle the file, it is closed automatically. This doesn't happen in the normal invocation, so if you use:

	f = File.open('2012-09-18-reading-and-writing-files-with-ruby.md')
	# => #<File:2012-09-18-reading-and-writing-files-with-ruby.md> 

You need to close the file later:
	
	f.close

While using a block is way easier:

	File.open('2012-09-18-reading-and-writing-files-with-ruby.md') do |f|
		puts f
		# => #<File:0x007fe5540237d0>
	end
	
+ Talk about the basic API

+ IO#readlines


# How to read from a file

+ Show a simple example that reads a file with some information in it (Code Jam stuff, maybe?)

Suppose you're using [Code Jam](http://code.google.com/codejam/)'s problems to improve your programming skills and you decided to be a hipster who uses Ruby. Ok, the first thing you need to be able to do is to read the .in files they send you, like this one:



# How to write to a file

+ Show a simple example that writes to a file (logging? Code Jam? bin/newpost?)

# The Dir class

+ When is it useful?
+ API: show the main methods (create new dir, temp dirs, iterate over all files)

# Further reading

+ [Working with files in Ruby](http://www.techotopia.com/index.php/Working_with_Files_in_Ruby)
+ [Input files in Ruby](http://www.ehow.com/how_2091655_input-file-ruby.html)
+ [I/O in Ruby](http://www.tutorialspoint.com/ruby/ruby_input_output.htm)