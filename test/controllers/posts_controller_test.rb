require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get timeline" do
    get posts_timeline_url
    assert_response :success
  end

end
