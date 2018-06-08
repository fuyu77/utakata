require 'test_helper'

class MySearchResultsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get my_search_results_index_url
    assert_response :success
  end

end
