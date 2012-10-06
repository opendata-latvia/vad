source 'https://rubygems.org'

gem 'rails', '3.2.8'

gem 'mysql2'

gem 'haml-rails'
gem 'simple_form'

gem 'redis'
gem 'redis-rails'

gem 'devise'
gem 'cancan'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass'
  gem 'sass-rails',   '~> 3.2.5'
  gem 'coffee-rails', '~> 3.2.2'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', :platform => :ruby

  gem 'uglifier', '>= 1.0.3'
  gem 'twitter-bootstrap-rails'
  gem 'jquery-datatables-rails'

  gem 'quiet_assets', :group => :development
end

gem 'jquery-rails'

group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'awesome_print', :require => 'ap'
end

group :development do
  gem 'thin' # to avoid webrick warnings about missing content-length
  gem 'capistrano', :require => false
  gem 'capistrano-ext', :require => false
end
