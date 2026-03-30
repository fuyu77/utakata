# frozen_string_literal: true

namespace :users do
  desc '作成から1日以上経過したメールアドレス未確認ユーザーを削除する'
  task destroy_not_confirmed: :environment do
    users = User.where(confirmed_at: nil).where(created_at: ...1.day.ago)

    if users.none?
      Rails.logger.info '削除対象のメールアドレス未確認ユーザーはいませんでした'
      next
    end

    Rails.logger.info "メールアドレス未確認ユーザーを#{users.count}件削除します"

    users.find_each do |user|
      Rails.logger.info(
        [
          "user_id=#{user.id}",
          "email=#{user.email}",
          "name=#{user.name}"
        ].join(' ')
      )
      user.destroy!
    end
  end
end
