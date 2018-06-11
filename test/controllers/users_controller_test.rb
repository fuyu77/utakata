require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get users_search_url
    assert_response :success
  end

end
