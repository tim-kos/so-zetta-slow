---
layout: post
title: "Command line options in Ruby"
date: 2013-01-19 23:51
tags: [en-us]
---

I was writing my [WordPress theme generator](http//github.com/agarie/wobbie) last week when I stumbled upon the problem of handling command line arguments. i've seen it in other programs, so I know there are *lots* of libraries for this task.

But I didn't need something too fancy, as Wobbie is a very simple tool. So I used OptionParser.

<!--more-->

Why is that? Mostly compatibility: it's part of Ruby's standard library. And it's extremely simple to use. For example:

		require 'optparser'

		options = {}
		opts = OptionParser.new do |opt|
		  # ...
		end
		opts.parse! # Empty the ARGV array.

And it'll generate a help automatically (with --help/-h), together with the options you created. For example:

		$ wobbie -h
		Wobbie is a WordPress theme generator.

		Basic Command Line Usage:
		wobbie # Create a ./theme directory from the standard template.

		You can configure it through the following options:

		    -s, --source DIR                 Use template from DIR instead of the standard one.
		    -b, --bower                      Create a components.json file for the theme.
		    -t, --theme NAME                 Specify the name of the generated theme.
		    -v, --version                    Print current version and exit.
		    -V, --verbose                    Print more information as the template is processed.

But how to create those options? The most important ones are true/false (on/off) switches and receiving parameters, for example regexps and directory/file names.

It's actually pretty simple:

		opts.on('-b', '--bower', 'Create a components.json file for the theme.') do |bower|
		  options['bower'] = true
		end

		opts.on('-s', '--source DIR', 'Use template from DIR instead of the standard one.') do |source_dir|
		  options['source_dir'] = source_dir
		end

The idea is that each option can have a parameter after it (`bower` and `source_dir`) and you use it as you see fit, e.g. just setting a flag on the options hash or using the actual content.

Ah, after you use the `parse!` method, the options are removed from the `ARGV` array, so you can still pass arguments without them being used by OptionParser.

There are various tools for parsing command line arguments in Ruby, [Thor being my favorite](https://github.com/wycats/thor) among them. When I need something more powerful, I'll write about it.