# frozen_string_literal: true

module ApplicationHelper
  AVATAR_IMAGE_DISPLAY_SIZES = {
    original: 75,
    medium: 35,
    small: 20
  }.freeze

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

  def avatar_image_tag(user, size, options = {})
    display_size = AVATAR_IMAGE_DISPLAY_SIZES.fetch(size)

    image_tag user.avatar.url(size), options.reverse_merge(width: display_size, height: display_size)
  end
end
