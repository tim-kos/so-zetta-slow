require "rake"
require "open-uri"

desc "Create a quotes.json file in the _data dir"
task :get_quotes, [:api_key_location] do |t, args|
  # Create _data dir if it doesn't exist.
  Dir.mkdir("./_data") unless File.directory? "./_data"
  
  api_url = "http://api.tumblr.com/v2/blog/turing-machine.tumblr.com/posts/quote?api_key="
  api_key_file = args.api_key_location || "./_data/api_key"  
  api_key = File.open(api_key_file, 'r').readlines.first
  
  File.open("./_data/quotes.json", 'w') do |f|
    f << open(api_url + api_key).readlines.first
  end
end