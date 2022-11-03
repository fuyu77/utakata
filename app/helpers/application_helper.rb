# frozen_string_literal: true

module ApplicationHelper
  def title(title)
    return 'Utakata - 短歌投稿サイト' if title.blank?

    "#{title} - 短歌投稿サイトUtakata"
  end

  def meta_description(description)
    return '短歌を投稿・共有できるサイトです。あなたの作品を縦書きで美しく表現します。' if current_page?(root_path)

    description
  end

  def og_image_url(image_url)
    return if image_url.blank?

    "https:#{image_url}"
  end

  def notifications_count
    notifications_count = Follow.where(user_id: current_user.id, read: false).count
    notifications_count.zero? ? nil : notifications_count
  end
end
