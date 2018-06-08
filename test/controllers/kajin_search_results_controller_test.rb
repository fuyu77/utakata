require 'test_helper'

class KajinSearchResultsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get kajin_search_results_index_url
    assert_response :success
  end

end
