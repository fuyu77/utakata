# frozen_string_literal: true

workers Integer(ENV.fetch('WEB_CONCURRENCY', nil) || 2)
threads_count = Integer(ENV.fetch('RAILS_MAX_THREADS', nil) || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV.fetch('PORT', nil)     || 3000
environment ENV.fetch('RACK_ENV', nil) || 'development'

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
end

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
