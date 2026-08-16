# frozen_string_literal: true

require 'test_helper'

describe CanonicalHostRedirect do
  describe '#call' do
    it 'Heroku標準ドメインへのアクセスをパスとクエリを維持して正規ドメインへ恒久的にリダイレクトする' do
      inner_app = ->(_env) { [200, { 'content-type' => 'application/test' }, ['response']] }
      middleware = CanonicalHostRedirect.new(inner_app)

      env = Rack::MockRequest.env_for(
        '/posts/1?ref=share',
        'HTTP_HOST' => 'utakatanka.herokuapp.com'
      )

      status, headers = middleware.call(env)

      assert_equal 308, status
      assert_equal 'https://utakatanka.jp/posts/1?ref=share', headers.fetch('location')
    end

    it '正規ドメインへのアクセスはそのまま処理する' do
      inner_app = ->(_env) { [200, { 'content-type' => 'application/test' }, ['response']] }
      middleware = CanonicalHostRedirect.new(inner_app)

      env = Rack::MockRequest.env_for(
        '/posts/1?ref=share',
        'HTTP_HOST' => 'utakatanka.jp'
      )

      status, headers = middleware.call(env)

      assert_equal 200, status
      assert_equal 'application/test', headers.fetch('content-type')
    end

    it '転送ヘッダーが正規ドメインでもHTTP_HOSTがHeroku標準ドメインならリダイレクトする' do
      inner_app = ->(_env) { [200, { 'content-type' => 'application/test' }, ['response']] }
      middleware = CanonicalHostRedirect.new(inner_app)
      env = Rack::MockRequest.env_for(
        '/posts/1',
        'HTTP_HOST' => 'utakatanka.herokuapp.com',
        'HTTP_FORWARDED' => 'host=utakatanka.jp',
        'HTTP_X_FORWARDED_HOST' => 'utakatanka.jp'
      )

      status, headers = middleware.call(env)

      assert_equal 308, status
      assert_equal 'https://utakatanka.jp/posts/1', headers.fetch('location')
    end

    it '転送ヘッダーがHeroku標準ドメインでもHTTP_HOSTが正規ドメインならリダイレクトしない' do
      inner_app = ->(_env) { [200, { 'content-type' => 'application/test' }, ['response']] }
      middleware = CanonicalHostRedirect.new(inner_app)
      env = Rack::MockRequest.env_for(
        '/posts/1',
        'HTTP_HOST' => 'utakatanka.jp',
        'HTTP_FORWARDED' => 'host=utakatanka.herokuapp.com',
        'HTTP_X_FORWARDED_HOST' => 'utakatanka.herokuapp.com'
      )

      status, = middleware.call(env)

      assert_equal 200, status
    end

    it 'Heroku以外のドメインへのアクセスはそのまま処理する' do
      inner_app = ->(_env) { [200, { 'content-type' => 'application/test' }, ['response']] }
      middleware = CanonicalHostRedirect.new(inner_app)

      env = Rack::MockRequest.env_for('/posts/1', 'HTTP_HOST' => 'example.com')

      status, = middleware.call(env)

      assert_equal 200, status
    end
  end
end
