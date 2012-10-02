#------------------------------------------------------------------------------
# QuotesGenerator
# A Jekyll plugin to generate a quotes/index.html page based on a Tumblr's
# account. 
#
# Available _config.yml settings:
# - 
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

      # Generate a list of quotes.
      string = ''
      quotes.each do |q|
        string << "<article class='quote'>"
        string << "<p>#{q['text']}</p>"
        string << "<p>- #{q['source']}</p>"
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
  end

  class QuoteGenerator < Generator
    safe true
    priority :low
    
    def generate(site)
      site.create_quotes_page
    end
      
  end
end