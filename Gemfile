# frozen_string_literal: true

gem "rake", ">= 12.3.3"

source "https://rubygems.org"

group :jekyll_plugins do
  gem "jekyll-feed"
  gem "jekyll-seo-tag"
  gem "jekyll-sitemap"
  gem "jekyll-spaceship"
  gem "jekyll-polyglot"
  gem "jekyll-minifier"
end

require 'rbconfig'
if RbConfig::CONFIG['target_os'] =~ /(?i-mx:bsd|dragonfly)/
    gem 'rb-kqueue', '>= 0.2'
end
