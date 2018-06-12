require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get follower" do
    get posts_follower_url
    assert_response :success
  end

end
