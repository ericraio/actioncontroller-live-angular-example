source 'https://rubygems.org'

gem 'rails', '4.0.0.rc1'
gem 'puma'

##
# Database
#
gem 'mongoid', github: 'mongoid/mongoid'
gem 'mongoid_search'
gem 'mongo_followable'
gem "mongoid-paperclip", :require => "mongoid_paperclip"

# Front End
#
gem 'turbolinks'
gem 'jquery-rails'
gem 'angularjs-rails'
gem 'bootstrap-sass', '~> 2.3.1.0'
gem "font-awesome-rails"
gem 'simple_form', github: 'plataformatec/simple_form' #remove simple_form
gem 'auto_html'
gem 'sass-rails', '4.0.0.rc1'
gem 'therubyracer', platforms: :ruby
gem 'uglifier', '>= 1.3.0'
gem 'gon'

group :development do
  gem 'guard-rspec'
  gem 'guard-puma'
  gem 'guard-redis'
  gem 'pry'
  gem 'quiet_assets'
end

group :development, :test do
  gem 'debugger'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'guard'
  gem 'guard-jasmine'
end

group :test do
  gem 'mongoid-rspec'
  gem 'ffaker'
  gem 'simplecov', require: false
  gem 'database_cleaner'
  gem 'cucumber-rails', require: false, github: 'dbruns/cucumber-rails'
  gem 'poltergeist'
  gem 'jasmine'
  gem 'sinon-rails'
end

gem 'the_games_db'
gem 'devise', github: 'plataformatec/devise', branch: 'rails4'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'recommendable' # http://davidcel.is/recommendable/

#
# brew install redis
#
gem 'redis'


#TODO: Gems to implement

# Newrelic
# gem 'newrelic'

# Whenever gem
# gem 'whenever'

# Gem for websockets https://github.com/ngauthier/tubesock
# gem 'tubesock'

# Gem for gamification https://github.com/tute/merit
# gem 'merit'
