# ExcerptGenerator
# Generates an excerpt for each post and makes it accessible as `post.excerpt`.
#
# This is basically a hack until Jekyll introduces excerpts officially.

module Jekyll
  class Post
    attr_accessor :excerpt
    
    def read_yaml(*args)
      super
      self.excerpt = self.extract_excerpt
    end
    
    def to_liquid
      self.data.deep_merge({
        "title" => self.data["title"] || self.slug.split('-').select {|w| w.capitalize! || w }.join(' '),
        "url" => self.url,
        "date" => self.date,
        "id" => self.id,
        "categories" => self.categories,
        "next" => self.next,
        "previous" => self.previous,
        "tags" => self.tags,
        "content" => self.content,
        "excerpt" => self.excerpt
      })
    end
        
    def extract_excerpt
      # Taking the idea from Octopress.
      sep = /<!--\s*more\s*-->/i
      
      head, _, tail = converter.convert(self.content).partition(sep)
      
      head
    end
  end
end