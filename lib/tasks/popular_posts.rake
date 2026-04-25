# frozen_string_literal: true

namespace :popular_posts do
  desc '人気の歌を集計し、掲載順データを更新する'
  task refresh: :environment do
    PopularPost.refresh!
    Rails.logger.info "人気の歌を#{PopularPost.count}件集計しました"
  end
end
