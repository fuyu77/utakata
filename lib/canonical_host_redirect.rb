# frozen_string_literal: true

class CanonicalHostRedirect
  CANONICAL_HOST = 'utakatanka.jp'
  HEROKU_HOST_PATTERN = /\A.+\.herokuapp\.com(?::\d+)?\z/i
  PERMANENT_REDIRECT = 308

  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    return @app.call(env) unless env['HTTP_HOST']&.match?(HEROKU_HOST_PATTERN)

    [PERMANENT_REDIRECT, { 'location' => "https://#{CANONICAL_HOST}#{request.fullpath}" }, []]
  end
end
