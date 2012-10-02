---
layout: post
title: How Jekyll works
tags: [en-us, ruby, jekyll]
date: 2012-10-02
---

Last saturday, I decided to build a Jekyll plugin to get the quotes from my Tumblr account (through a quotes.json file conveniently saved using a Rake task, inspired by [1]) and generate a "quotes index".

So... I needed a generator. (d'oh)

There's an example in the [Github wiki](https://github.com/mojombo/jekyll/wiki/Plugins):

	module Jekyll

	  class CategoryPage < Page
	    def initialize(site, base, dir, category)
	      @site = site
	      @base = base
	      @dir = dir
	      @name = 'index.html'

	      self.process(@name)
	      self.read_yaml(File.join(base, '_layouts'), 'category_index.html')
	      self.data['category'] = category

	      category_title_prefix = site.config['category_title_prefix'] || 'Category: '
	      self.data['title'] = "#{category_title_prefix}#{category}"
	    end
	  end

	  class CategoryPageGenerator < Generator
	    safe true
    
	    def generate(site)
	      if site.layouts.key? 'category_index'
	        dir = site.config['category_dir'] || 'categories'
	        site.categories.keys.each do |category|
	          site.pages << CategoryPage.new(site, site.source, File.join(dir, category), category)
	        end
	      end
	    end
	  end

	end
	
After some hacking, I started to think it wasn't as easy as it appeared. Ok, coding while being sleep-deprived isn't very smart.

I started again after some hours of sleep and sufficient caffeine, but this time desiring to understand how Jekyll works. I imagined some kind of data structure holding all the generators, some other holding the converters and they were called during the "compilation" of the site. But something was missing: when are the files read from the filesystem? How to generate a file without an initial template, effectively creating the file during "compile-time"?

I started with the Jekyll executable. It's pretty simple: the command-line parameters, the defaults and the `_config.yml` (through `Jekyll::configuration` method) are used to create an `options` hash and then a new site is instantiated:

	# Create the Site
	site = Jekyll::Site.new(options)
	
After that, it starts to watch the necessary directories if the `--auto` option was used.

	if options['auto']
	  require 'directory_watcher'
	  puts "Auto-regenerating enabled: #{source} -> #{destination}"
		# ...
	else
	  puts "Building site: #{source} -> #{destination}"
		# ...
	end

The site is built through a call to `site.process`, the main method in the `Jekyll::Site` class. Finally, it runs the local server if `--server` was specified.

I was happy, but didn't yet understand how my blog was created. Well, the `site.process` call was the obvious answer, so I opened `lib/jekyll/site.rb` on TextMate:

	def process
	  self.reset
	  self.read
	  self.generate
	  self.render
	  self.cleanup
	  self.write
	end

And it turned out to be very similar to my initial guess. For sake of completeness: `site.reset` and `site.setup` are called during initialization of the site to initialize its data structures and to load libraries, plugins, generators and converters, respectively. Ok, let's see what each of these methods do:

+ reset: initialize the layouts, categories and tags hashes and the posts, pages and static_files arrays.
+ read: get site data from the filesystem and store it in internal data structures.
+ generate: call each of the generators' `generate` method.
+ render: call the `render` method for each post and page.
+ cleanup: All pages, posts and static_files are stored in a `Set` and everything else (unused files, empty directories) is deleted.
+ write: call the `write` method of each post, page and static_file, copying them to the destination folder.

So if I wanted to create a generator, I just needed a `generate` method. Pretty easy. But there were some doubts still: How to specify a layout for my page through code, without creating a previous file on the filesystem?

The `Jekyll::Site.read` method stores the contents from the filesystem in internal data structures. This is the stage where the files in \_layouts, \_posts and possibly other directories are read and their respective objects (`Layout`, `Post`, `Page` and `StaticFile`) are stored inside arrays.

So, my page should be created dynamically by my generator. Nice. I did it, but after some tests, the `quotes/` directory wasn't being created.

The catch is the `Jekyll::Site.cleanup` method: it'll remove from the destination everything that isn't inside the internal data structures, including empty directories. So the solution was easy:

	self.pages << quotes_page
	
Just add the page to the site.pages array before returning. To understand what I'm saying, take a look at the plugin (after all this code archeology, it's amazing how simple it turned out to be). The current code for the generator [can be found in this gist](https://gist.github.com/3816637).

I wrote a [How Jekyll works?](https://github.com/mojombo/jekyll/wiki/How-Jekyll-works) page for the wiki in Jekyll's repository to help others interested in this.

# Sources

[1] [Generating Jekyll pages from data](http://jimpravetz.com/blog/2011/12/generating-jekyll-pages-from-data/)  
[2] [Jekyll git repository](https://github.com/mojombo/jekyll)