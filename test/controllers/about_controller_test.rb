# frozen_string_literal: true

require 'test_helper'

describe AboutController do
  describe '#index' do
    it 'ページを表示する' do
      get about_index_path

      assert_response :success
    end
  end
end
