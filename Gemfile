source 'http://rubygems.org'
gem 'rails', '3.2.13'
gem 'pg'
gem 'jquery-ui-rails'
gem 'jquery-rails', "~> 2.3.0"

gem "devise"
gem "cancan"
gem 'haml'
gem 'simple_form'

gem 'databasedotcom'
gem "cocoon"
gem 'settingslogic'
gem 'money'

gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sinatra', require: false
gem 'slim'

gem 'wicked'
gem 'enumerize'
gem 'foreigner'
gem 'activerecord-postgres-hstore'
gem 'postgres_ext'

gem 'carrierwave'
gem 'mini_magick'
gem 'rmagick'
gem 'jquery-fileupload-rails'

gem 'unicorn' # Use unicorn as the app server
gem 'capistrano' # Deploy with Capistrano
gem 'capistrano-sidekiq'

gem 'http_accept_language'
gem 'select2-rails'
gem 'font-awesome-rails'
gem 'country_select'
gem 'refinerycms', '~> 2.1.0'

gem "searchkick"
gem 'ransack'

gem 'braintree'
gem 'faraday'

#gem 'carmen-rails'
# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'susy'
  gem 'compass-rails'
  gem 'compass-susy-plugin'
  gem 'uglifier', '>= 1.0.3'
end



group :development do
  gem 'letter_opener'
  gem 'hooves' # Unicorn Rack handler for `rails s`

  # Speed and testing Tools (not needed on testing/integration server)
  gem 'guard'
  gem 'rb-fsevent'
  gem 'zeus'
  gem 'guard-rspec'
end

group :test, :development do
  gem 'rspec'
  gem 'rspec-rails', ">= 2.0"
  gem 'shoulda-matchers'
  gem 'factory_girl', ">= 4.2.0"
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'poltergeist'
  gem 'rr'
  gem 'ffaker'
  gem 'database_cleaner'
  gem 'ruby_gntp'
  gem 'fuubar'
  gem 'railroady'

  # Debugger and REPL
  gem "pry"
  gem "pry-debugger"
end

group :test do
  gem 'fake_braintree'
end
