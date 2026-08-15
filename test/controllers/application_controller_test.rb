# frozen_string_literal: true

require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest
  describe '#ensure_domain' do
    it '独自ドメインへのアクセスはリダイレクトしない' do
      host! 'utakatanka.jp'

      get about_index_path

      assert_response :success
    end
  end
end
