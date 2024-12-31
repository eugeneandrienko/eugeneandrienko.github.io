# frozen_string_literal: true

gem "jekyll-sass-converter", "~> 2.0"
gem "rake", ">= 12.3.3"

source "https://rubygems.org"
gemspec

group :jekyll_plugins do
  gem "jekyll-pdf-embed"
  gem "jekyll-polyglot"
end

require 'rbconfig'
if RbConfig::CONFIG['target_os'] =~ /(?i-mx:bsd|dragonfly)/
    gem 'rb-kqueue', '>= 0.2'
end
