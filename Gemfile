source 'https://rubygems.org'

gem 'rails', '3.2.18'
gem 'rake', '10.3.2'

gem 'mysql2'

gem 'haml-rails'
gem 'simple_form'

gem 'will_paginate', '~> 3.0'

gem 'redis'
gem 'redis-rails', '~> 3.2.3'

gem 'devise', '~> 2.2.3'
gem 'devise_invitable', '~> 1.1.4'
gem 'cancan', '~> 1.6.2'

gem 'settingslogic'

gem 'httparty', '~> 0.14.0'
gem 'nokogiri', '~> 1.6.8'

gem 'rubyzip', '~> 1.2.0', :require => 'zip'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass'
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails', '~> 2.1.3'
  gem 'jquery-datatables-rails', '~> 1.11.1'

  gem 'quiet_assets', :group => :development
end

gem 'jquery-rails'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'awesome_print', :require => 'ap'
  gem 'pry'
end

group :development do
  gem 'guard'
  gem 'rb-fsevent'
  gem 'growl'
  gem 'guard-rspec'
  gem 'guard-livereload'

  gem 'thin' # to avoid webrick warnings about missing content-length
  gem 'sprinkle', :require => false
  gem 'capistrano', :require => false
  gem 'capistrano-ext', :require => false
end
