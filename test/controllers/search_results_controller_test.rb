require 'test_helper'

class SearchResultsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get search_results_index_url
    assert_response :success
  end

end
