# frozen_string_literal: true

require 'test_helper'

describe DonationsController do
  describe '#index' do
    it 'ページを表示する' do
      get donations_path

      assert_response :success
    end
  end
end
