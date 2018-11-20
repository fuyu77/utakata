# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should get follow' do
    get users_follow_url
    assert_response :success
  end

  test 'should get follower' do
    get users_follower_url
    assert_response :success
  end
end
