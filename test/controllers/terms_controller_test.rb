# frozen_string_literal: true

require 'test_helper'

describe TermsController do
  describe '#index' do
    it 'ページを表示する' do
      get terms_path

      assert_response :success
    end
  end
end
