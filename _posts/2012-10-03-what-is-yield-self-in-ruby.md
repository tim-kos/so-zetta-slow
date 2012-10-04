---
layout: post
title: What is yield self in Ruby
tags: [en-us, ruby, code block, closure, anonymous, functions]
---

A question that arises almost every week on #ruby-lang is this:

> I know how to create code blocks for my methods, but what is this `yield self`?

After trying to explain it every time, I started to use [this gist](https://gist.github.com/3803259#file_first.rb). And now I'm writing a blog post about it. Yeah, it's that recurrent.

I'm going to assume you know what a code block is - a piece of code that receives an `|argument|` as parameter and does some computation, like in `Array#each` or `String#each_line`. But iterators like these aren't the only use for them.

In my post [about how to do File I/O in Ruby](/2012/09/26/reading-and-writing-files-with-ruby.html), I talked about `File::open` accepting a code block:

	File.open("_posts/2012-10-03-what-is-yield-self-in-ruby.md", 'r') do |file|
	  puts file
	end
	
	# => #<File:0x007fa141185878>
	
As you can see, the `file` variable is in fact the opened object inside the block. After calling the code block, file.close is called before passing control back to your code, avoiding "Oh, I forgot to close this file" kind of errors. (the operating system won't let you open more files if you don't close the ones you already used)

Let's create the `Pokemon` class:

<script src="https://gist.github.com/3803259.js?file=second.rb"></script>

As you can see, inside the code block you can call the method `use_move` on the argument passed to it. This means that when you call `yield self` inside your method, you're passing *the object* as a parameter.

It's a parameter like any other object. And why is this useful? Well, house-keeping like calling a method after the block, but before control is returned to the program (logging is a nice example) and configuration, like in [`ActiveRecord`](http://guides.rubyonrails.org/migrations.html).

	class CreateProducts < ActiveRecord::Migration
	  def up
	    create_table :products do |t|
	      t.string :name
	      t.text :description
 
	      t.timestamps
	    end
	  end
 
	  def down
	    drop_table :products
	  end
	end

In this migration, look at the `create_table` method, receiving a code block in which `t` is a parameter - it's the table being created. And all the methods called on it - `string`, `text`, `timestamps` - are used to generate columns.

I hope that this blog post helps people understand what `yield self` means. Truly.

# Further reading

[How to write a method that uses code blocks](http://blog.codahale.com/2005/11/24/a-ruby-howto-writing-a-method-that-uses-code-blocks/)