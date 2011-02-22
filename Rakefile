require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name = "skinnycms_tumblr"
  gem.homepage = "https://github.com/fiftyandfifty/skinnycms_tumblr"
  gem.license = "MIT"
  gem.summary = "Lightweight CMS which leverages the lastest external social networking APIs"
  gem.description = "long description"
  gem.email = "ruslan.hamidullin@flatsoft.com"
  gem.authors = ["RuslanHamidullin"]
end
Jeweler::RubygemsDotOrgTasks.new

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }

