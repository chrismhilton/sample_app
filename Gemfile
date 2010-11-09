source 'http://rubygems.org'

gem 'rails', '3.0.0'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

# change to prevent heroku from trying to load the sqlite3-ruby gem
gem 'sqlite3-ruby', '1.2.5', :group => :development #:require => 'sqlite3'

#
# include the gems for RSpec and the RSpec library specific to Rails
#

# include rspec in development mode for access to the RSpec-specific generators
group :development do
  gem 'rspec-rails', '2.0.1'
end

# include rspec in test mode in order to run tests
group :test do
  gem 'rspec', '2.0.1'
  gem 'webrat', '0.7.1'

  # needed to run 'bundle exec autotest'
  gem 'autotest'
  gem 'autotest-growl'
  gem 'autotest-notification'
  gem 'autotest-rails-pure'
end

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
# group :development, :test do
#   gem 'webrat'
# end
