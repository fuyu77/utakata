# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'acts_as_follower', github: 'fuyu77/acts_as_follower'
gem 'bootsnap', require: false
gem 'devise'
gem 'jsbundling-rails'
gem 'kaminari'
gem 'kt-paperclip'
gem 'omniauth'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-twitter'
gem 'pg'
gem 'propshaft'
gem 'puma'
gem 'rails'
gem 'rails-html-sanitizer'
gem 'rinku'
gem 'turbo-rails'

group :development do
  gem 'bullet'
  gem 'foreman'
  gem 'listen'
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
end

group :production do
  gem 'aws-sdk-s3'
end

ruby '3.1.2'
