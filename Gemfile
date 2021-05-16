# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'acts_as_follower', github: 'fuyu77/acts_as_follower'
gem 'devise', '~> 4.7.3'
gem 'kaminari'
gem 'kt-paperclip'
gem 'omniauth', '~> 1.9.0'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-twitter'
gem 'puma'
gem 'rails'
gem 'rails-html-sanitizer'
gem 'rinku'
gem 'webpacker', '~> 5.2.1'

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'capybara'
  gem 'selenium-webdriver'
end

group :development do
  gem 'listen'
  gem 'mysql2'
  gem 'rubocop-rails', require: false
  gem 'solargraph', require: false
  gem 'spring'
  gem 'spring-watcher-listen'
  gem 'web-console'
end

group :production do
  gem 'aws-sdk-s3'
  gem 'google-analytics-rails'
  gem 'pg'
end

ruby '3.0.1'
