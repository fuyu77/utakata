# frozen_string_literal: true

module SqlQueries
  extend ActiveSupport::Concern

  class_methods do
    def like(column_name, keyword)
      where("#{column_name} LIKE ?", "%#{keyword}%")
    end

    def order_by_ids(ids)
      order_by = ['CASE']
      ids.each_with_index do |id, index|
        order_by << "WHEN id='#{id}' THEN #{index}"
      end
      order_by << 'END'
      order(Arel.sql(order_by.join(' ')))
    end
  end
end
