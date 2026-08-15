# frozen_string_literal: true

require 'test_helper'

{
  AboutController => :about_index_path,
  DonationsController => :donations_path,
  PrivacyController => :privacy_index_path,
  TermsController => :terms_path
}.each do |controller_class, path_helper|
  describe controller_class do
    describe '#index' do
      it 'ページを表示する' do
        get public_send(path_helper)

        assert_response :success
      end
    end
  end
end
