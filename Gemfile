# frozen_string_literal: true

source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'acts_as_follower', github: 'fuyu77/acts_as_follower'
gem 'devise'
gem 'kaminari'
gem 'kt-paperclip'
gem 'omniauth'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-twitter'
gem 'pg'
gem 'puma'
gem 'rails'
gem 'rails-html-sanitizer'
gem 'rinku'
gem 'webpacker'

group :development do
  gem 'bullet'
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'listen'
  gem 'rubocop-rails', require: false
  gem 'solargraph', require: false
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :production do
  gem 'aws-sdk-s3'
end

ruby '3.0.2'
