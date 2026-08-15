# frozen_string_literal: true

require 'test_helper'

describe CanonicalHostRedirect do
  describe '#call' do
    it 'Heroku標準ドメインへのアクセスをパスとクエリを維持して正規ドメインへ恒久的にリダイレクトする' do
      inner_app = ->(_env) { [200, { 'content-type' => 'application/test' }, ['response']] }
      middleware = CanonicalHostRedirect.new(inner_app)

      status, headers = middleware.call(Rack::MockRequest.env_for('https://utakatanka.herokuapp.com/posts/1?ref=share'))

      assert_equal 301, status
      assert_equal 'https://utakatanka.jp/posts/1?ref=share', headers.fetch('location')
    end

    it '正規ドメインへのアクセスはそのまま処理する' do
      inner_app = ->(_env) { [200, { 'content-type' => 'application/test' }, ['response']] }
      middleware = CanonicalHostRedirect.new(inner_app)

      status, headers = middleware.call(Rack::MockRequest.env_for('https://utakatanka.jp/posts/1?ref=share'))

      assert_equal 200, status
      assert_equal 'application/test', headers.fetch('content-type')
    end

    it 'Heroku以外のドメインへのアクセスはそのまま処理する' do
      inner_app = ->(_env) { [200, { 'content-type' => 'application/test' }, ['response']] }
      middleware = CanonicalHostRedirect.new(inner_app)

      status, = middleware.call(Rack::MockRequest.env_for('https://example.com/posts/1'))

      assert_equal 200, status
    end
  end
end
