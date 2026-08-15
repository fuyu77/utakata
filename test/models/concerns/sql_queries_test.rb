# frozen_string_literal: true

require 'test_helper'

class SqlQueriesTestModel < ApplicationRecord
  self.table_name = 'posts'

  include SqlQueries
end

describe SqlQueries do
  describe '.like' do
    it '指定したカラムを部分一致で検索する' do
      assert_equal [posts(:hanako_first).id], SqlQueriesTestModel.like('tanka', '春').pluck(:id)
    end
  end

  describe '.order_by_ids' do
    it '指定したIDの順番で並べる' do
      ids = [posts(:jiro_first).id, posts(:hanako_first).id, posts(:taro_first).id]

      assert_equal ids, SqlQueriesTestModel.where(id: ids).order_by_ids(ids).pluck(:id)
    end
  end
end
