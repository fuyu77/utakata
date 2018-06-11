require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  test "should get search" do
    get posts_search_url
    assert_response :success
  end

  test "should get search_mine" do
    get posts_search_mine_url
    assert_response :success
  end

end
