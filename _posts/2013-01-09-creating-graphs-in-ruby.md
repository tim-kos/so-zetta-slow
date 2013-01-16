---
layout: post
title: "Creating graphs in Ruby"
date: 2013-01-09 21:48
tags: [en-us, ruby, rubyvis, sciruby]
---

I was trying to make some graphics with Ruby to test features of [SciRuby][sciruby]. Well, I know [Rubyvis][rubyvis site], which was created by [Claudio Bustos](https://github.com/clbustos) some time ago -- it's a gem to create SVG files.

<!--more-->

A SVG (Scalable Vector Graphics) file is: 

<blockquote>
(...) an XML-based vector image format for two-dimensional graphics that has support for interactivity and animation. The SVG specification is an open standard developed by the World Wide Web Consortium (W3C) since 1999.

(...)

All major modern web browsers (...) have at least some degree of support for SVG and can render the markup directly.
<small>
	<a href="http://en.wikipedia.org/wiki/Scalable_Vector_Graphics">Wikipedia</a>
</small>
</blockquote>

That's enough for me. Let's see how to install it.

## Installing

First, I'm on OS X, so I'm going to use Homebrew. If you're on Linux, use your favorite package manager. The first thing to install is [Cairo][cairo website], which can be done simply by:

		brew install cairo

Then install the gem:

		gem install rubyvis

Now you're ready to use it. Just browse through the [Rubyvis documentation][rubyvis docs] or use the sample program to see if it's working:

		require 'rubyvis'

		vis = Rubyvis::Panel.new do 
		  width 150
		  height 150
		  bar do
		    data [1, 1.2, 1.7, 1.5, 0.7, 0.3]
		    width 20
		    height {|d| d * 80}
		    bottom(0)
		    left {index * 25}
		  end
		end

		vis.render()
		File.open("test.svg", "w") do |f|
		  f.write(vis.to_svg) # Write the SVG content on the file.
		end

And you should be done. But how to view it outside of a browser (or if you want to post it somewhere, blabla)? Use the [`rsvg` command line utility][rsvg command] to convert svg to png. First, the gem:

		gem install rsvg2

In my system, I had a problem with `libpixman`. Apparently `rsvg` wasn't looking my PATH correctly, so I just created a symlink:

		ln -s /usr/local/Cellar/pixman/0.24.4/lib/libpixman-1.0.24.4.dylib \
		      /usr/local/lib/libpixman-1.0.24.4.dylib

And it worked:

		rsvg test.svg test.png

![The graphic](/images/test.png)

## Other solution

Rubyvis is obviously powerful enough to create almost anything I might need (ok, I have MATLAB for surface plots), but its syntax isn't very... attractive. I want to create wrappers and make it easy enough to create common stuff, like in the R programming language -- which I've been studying for the past weeks.

I found another project for graphics in Ruby, with support for JRuby, [called Gruff][gruff repo]. I didn't have time to test it this week, but seems interesting enough. Maybe another day.

[rsvg command]: http://linux.about.com/library/cmd/blcmdl1_rsvg.htm
[cairo website]: http://www.cairographics.org/
[rubyvis site]: http://rubyvis.rubyforge.org/
[rubyvis docs]: http://rubyvis.rubyforge.org/rubyvis/
[sciruby]: http://sciruby.com
[gruff repo]: https://github.com/topfunky/gruff