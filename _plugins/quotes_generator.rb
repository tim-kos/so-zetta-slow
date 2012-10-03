#------------------------------------------------------------------------------
# QuotesGenerator
# A Jekyll plugin to generate a quotes/index.html page based on a Tumblr's
# account. 
#
# Available _config.yml settings:
# - text_size_limit: Maximum size of a used quote. Default to 1000.
#
#------------------------------------------------------------------------------

require 'json'

module Jekyll
  
  class QuotesPage < Page
    attr_accessor :content, :data
    
    def initialize(site, base, dir, name)
      @site = site
      @base = base
      @dir  = dir
      @name = name
      
      self.process(name)
      self.content = ''
      self.data = {}
    end
  end
  
  class Site
    
    def create_quotes_page
      quotes_page = QuotesPage.new(self, self.source, 'quotes', 'index.html')
      
      # Get the quotes from the JSON.
      quotes = get_quotes
      
      # Get the configurations from _config.yml. Default to 1000.
      self.config['text_size_limit'] ||= 1000
      
      # Remove noise from the quotes.
      quotes = remove_noise(quotes)
      
      # Generate a list of quotes. It isn't worth to require Nokogiri for such
      # a tiny string.
      string = ''
      string << "<p>These quotes are automatically fetched from my Tumblr account"
      string << "<a href='http://turing-machine.tumblr.com'>turing-machine</a>.</p>"
      quotes.each do |q|
        string << "<blockquote>"
        string << "#{q['text']}"
        string << "<small>#{q['source']}</small>"
        string << "</blockquote>"
      end
            
      quotes_page.content = string
      quotes_page.data["layout"] = "default"
      
      self.pages << quotes_page      
    end
    
    def get_quotes
      response = JSON.parse(File.open("./_data/quotes.json", 'r').readlines.first)["response"]
      posts = response["posts"]
      posts
    end

    def remove_noise(quotes)
      quotes.select do |quote|
        quote["text"].size < self.config['text_size_limit']
      end.delete_if do |quote|
        # Remove quotes with images.
        quote["text"] =~ /<img/ || quote["source"] =~ /<img/
      end
    end
  end

  class QuoteGenerator < Generator
    safe true
    priority :low
    
    def generate(site)
      site.create_quotes_page
    end
      
  end
end
