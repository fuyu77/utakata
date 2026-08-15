# frozen_string_literal: true

require 'test_helper'

class SqlQueriesTest < ActiveSupport::TestCase
  test '指定したカラムを部分一致で検索する' do
    assert_equal [posts(:alice_first)], Post.like('tanka', '春').to_a
  end

  test '指定したIDの順番で並べる' do
    ids = [posts(:carol_first).id, posts(:alice_first).id, posts(:bob_first).id]

    assert_equal ids, Post.where(id: ids).order_by_ids(ids).pluck(:id)
  end
end
