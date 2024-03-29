# frozen_string_literal: true

source 'https://rubygems.org'
ruby '3.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.5'
gem 'rails-erd'
gem 'carrierwave', '~> 2.2.2'
gem 'carrierwave-base64', '~> 2.10.0'
gem 'delayed_job_active_record', '~> 4.1.7'
gem 'annotate', '~> 3.2.0'
gem 'counter_culture', '~> 3.2.1'
gem 'devise', '~> 4.8.1'
gem 'devise_token_auth', '~> 1.2.0'
gem 'draper', '~> 4.0.2'
gem 'fog-aws', '~> 3.13.0'
gem 'font-awesome-rails'
gem 'haml-rails', '~> 2.0.1'
gem 'jbuilder', '~> 2.11.5'
gem 'jquery-rails'
gem 'kaminari', '~> 1.2.2'
gem 'koala', '~> 3.1.0'
gem 'net-smtp', require: false
gem 'oj', '~> 3.13.11'
gem 'pg', '~> 1.3.5'
gem 'pry-rails', '~> 0.3.9'
gem 'puma', '~> 5.6.4'
gem 'rack-cors', '~> 1.1.1'
gem 'rails_admin', '~> 3.0.0'
gem 'rollbar', '~> 3.3.0'
gem 'sass-rails', '~> 6.0.0'
gem 'sendgrid', '~> 1.2.4'
gem 'tilt', '~> 2.0.10'
gem 'turbolinks'
gem 'wdm', '~> 0.1.1' if RbConfig::CONFIG['target_os'] =~ /mswin|mingw/i

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'bullet', '~> 7.0.1'
  gem 'factory_bot', '~> 6.2.1'
  gem 'factory_bot_rails'
  gem 'faker', '~> 2.20.0'
  gem 'pry-byebug', '~> 3.9.0', platform: :mri
  gem 'rails-controller-testing', '~> 1.0.5'
  gem 'rspec-core', '~> 3.11.0'
  gem 'rspec-rails', '~> 5.1.1'
end

group :development do
  gem 'better_errors', '~> 2.9.1'
  gem 'binding_of_caller', '~> 1.0.0'
  gem 'brakeman', '~> 5.2.1'
  gem 'guard-ctags-bundler'
  gem 'letter_opener', '~> 1.8.1'
  gem 'listen', '~> 3.7.1'
  gem 'rails_best_practices', '~> 1.23.1'
  gem 'reek', '~> 6.1.0'
  gem 'rubocop', '~> 1.26.1'
  gem 'spring', '~> 2.1.1'
  gem 'spring-watcher-listen', '~> 2.0.1'
end

group :test do
  gem 'database_cleaner', '~> 2.0.1'
  gem 'net-imap', require: false
  gem 'net-pop', require: false
  gem 'shoulda-matchers', '~> 5.1.0'
  gem 'simplecov', '~> 0.21.2', require: false
  gem 'webmock', '~> 3.14.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'sassc-rails', '~> 2.1.2'
gem 'tzinfo-data', '~> 1.2022.1'
