require 'test_helper'

class NewArrivalsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get toppages_index_url
    assert_response :success
  end

end
