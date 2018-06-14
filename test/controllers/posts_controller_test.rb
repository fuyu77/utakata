require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get favorite" do
    get posts_favorite_url
    assert_response :success
  end

end
