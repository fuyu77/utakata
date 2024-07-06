# frozen_string_literal: true

class ChangeColumnsNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :posts, :user_id, false # rubocop:disable Rails/BulkChangeTable
    change_column_null :posts, :tanka, false, ''
    change_column_null :posts, :published_at, false
  end
end
