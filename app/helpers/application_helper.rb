# frozen_string_literal: true

module ApplicationHelper
  def title
    title = 'Utakata - 短歌投稿サイト'
    title = @title + ' - 短歌投稿サイトUtakata' if @title.present?
    title
  end

  def meta_description
    description = ''
    if current_page?(root_path)
      description = '短歌を投稿・共有できるサイトです。あなたの作品を縦書きで美しく表現します。'
    elsif @description.present?
      description = @description
    end
    description
  end

  def og_image_url
    url = ''
    url = 'https:' + @image_url if @image_url.present?
    url
  end

  def notifications_count
    notifications_count = Follow.where(user_id: current_user.id, read: false).count
    if notifications_count.zero?
      nil
    else
      notifications_count
    end
  end
end
