---
layout: post
title: Reading and writing files with Ruby
tags: [en-us, ruby, io]
---

I use Ruby to automate a good amount of daily tasks. They all involve manipulating files in some way: writing logs, creating testbenches for VHDL and some exercises from [Code Jam](http://code.google.com/codejam/), to cite a few.

In this post, I'm going to describe how to do basic file I/O in Ruby, for it *is* useful and actually necessary even for basic scripting tasks. Let's start.

# The File class

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
	
There are lots of useful methods in this class. You have a command line tool and want to create a symlink in the /usr/bin folder? Use `File::symlink`. Need the path of some file? `File::realpath`. Also the extension? `File::extname`.

I've used these methods, but there're much, much more. [Read the documentation for details](http://www.ruby-doc.org/core-1.9.3/File.html).


# How to read from a file

[Code Jam](http://code.google.com/codejam/) is a coding competition hosted by Google to test the abilities of the participants in questions about algorithms (and how to implement them). There are some tricky problems, but this isn't the reason I'm talking about it.

Suppose you're using their problems to improve your programming skills and you decided to be a hipster who uses Ruby. Ok, the first thing you need to be able to do is to read the .in files they send you, like this one:

	1000
	3
	1 -5 3
	-2 1 4
	5
	5 4 3 1 2
	1 1 0 1 0

This is from the problem [Minimum Scalar Product](http://code.google.com/codejam/contest/32016/dashboard#s=p0). The first line is the number of test cases and, after that, each one is composed of 3 lines: the dimensions of the vectors and their respective elements. How could we get all this info?

The solution is simple if you use Ruby's APIs correctly.

	File.open("A-small-practice.in", 'r') do |f|
	  tests = f.readlines # tests is an array in which each entry is a line.
    
	  tests[1..-1].each_slice(3) do |data|
	    size = data.first.chomp.to_i
	    vector1 = data[1].chomp.split(" ").map { |str| str.to_i }
	    vector2 = data[2].chomp.split(" ").map { |str| str.to_i }
    
	    output << min_scalar_product(size, vector1, vector2)
	  end
	end

Open the file, create an array of lines with `File#readlines` (actually `IO#readlines`), then iterate over the tests, 3 lines at a time using `Array#each_slice`. The apparently difficult method chain in

	vector1 = data[1].chomp.split(" ").map { |str| str.to_i }

is simply a way to get an array of number from the string. First remove (chomp) the newline character, split them into an array and convert each string to a number.

The second parameter to `File::open` is a mode used to specify what you want to do with the opened file. All the available modes can be found at [the Ruby IO class documentation](http://ruby-doc.org/core-1.9.3/IO.html). As you might guess, `'r'` means we're opening the file to read it.

# How to write to a file

One of my ideas when I started this blog was of using [Jekyll](https://github.com/mojombo/jekyll), a Ruby program to generate static sites. No more wrestling with databases and super easy deployment sounded good enough.

Time passes by, and when I did the last redesign and wrote some posts, using `mkdir 2012-month-day-title.md` to create a new post turned out to be boring and very error-prone. To solve this, I made a simple script that resides in blog/bin/newpost and use it like this:

	$ bin/newpost "Reading and writing files with Ruby"

It's very simple and straightforward, without most of the Cool Stuff that'd be nice in a "true" command-line program:

	date_prefix = Time.now.strftime("%Y-%m-%d")
	postname = ARGV[0].strip.downcase.gsub(/ /, '-')

	header = <<-END
	---
	layout: post
	title: #{ARGV[0]}
	tags: [en-us, ]
	---

	END

	post = "./_posts/#{date_prefix}-#{postname}.md"

	File.open(post, 'w+') do |f|
	  f << header
	end

The complete script is [available as a gist](https://gist.github.com/3791939). I want to improve it to handle tags as command-line arguments, so I'll probably write a post about the OptionParser class someday.

The `File.open` is creating a file in the format specified, with the name given as a command-line option (using `ARGV[0]`). The `'w+'` identifier is a mode, like `'r'`.

# Further reading

+ [Working with files in Ruby](http://www.techotopia.com/index.php/Working_with_Files_in_Ruby)
+ [I/O in Ruby](http://www.tutorialspoint.com/ruby/ruby_input_output.htm)
+ [File class documentation](http://www.ruby-doc.org/core-1.9.3/File.html)