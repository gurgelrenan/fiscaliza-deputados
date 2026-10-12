source 'https://rubygems.org'

ruby file: '.ruby-version'

gem 'rails', '~> 8.1.4'
gem 'propshaft'
gem 'pg', '~> 1.6'
gem 'puma', '>= 6.0'
gem 'importmap-rails'
gem 'turbo-rails'
gem 'stimulus-rails'
gem 'jbuilder'
gem 'redis', '>= 4.0.1'
gem 'faraday', '~> 2.0'
gem 'bootsnap', require: false
gem 'tzinfo-data', platforms: %i[windows jruby]

group :development, :test do
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
  gem 'rspec-rails', '~> 8.0'
  gem 'factory_bot_rails'
  gem 'awesome_print'
end

group :test do
  gem 'webmock'
end

group :development do
  gem 'web-console'
end
