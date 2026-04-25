# frozen_string_literal: true

namespace :popular_posts do
  desc '人気の歌の掲載順データを再集計する'
  task rebuild: :environment do
    PopularPost.rebuild!
    Rails.logger.info "人気の歌を#{PopularPost.count}件集計しました"
  end
end
