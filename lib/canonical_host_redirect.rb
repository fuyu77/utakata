# frozen_string_literal: true

class CanonicalHostRedirect
  CANONICAL_HOST = 'utakatanka.jp'
  HEROKU_HOST_PATTERN = /\A.+\.herokuapp\.com\z/
  PERMANENT_REDIRECT = 301

  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    return @app.call(env) unless request.host.match?(HEROKU_HOST_PATTERN)

    [PERMANENT_REDIRECT, { 'location' => "https://#{CANONICAL_HOST}#{request.fullpath}" }, []]
  end
end
