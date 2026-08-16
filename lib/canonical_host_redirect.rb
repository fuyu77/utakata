# frozen_string_literal: true

class CanonicalHostRedirect
  CANONICAL_HOST = 'utakatanka.jp'
  HEROKU_HOST = 'utakatanka.herokuapp.com'
  PERMANENT_REDIRECT = 308

  def initialize(app)
    @app = app
  end

  def call(env)
    request = Rack::Request.new(env)

    return @app.call(env) unless env['HTTP_HOST'] == HEROKU_HOST

    [PERMANENT_REDIRECT, { 'location' => "https://#{CANONICAL_HOST}#{request.fullpath}" }, []]
  end
end
