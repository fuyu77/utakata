require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get notification" do
    get posts_notification_url
    assert_response :success
  end

end
