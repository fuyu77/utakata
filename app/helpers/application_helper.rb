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

  def search_word(search)
    search_word = '全件表示'
    search_word = '「' + search + '」で検索' if search.present?
    search_word
  end

  def all_tankas
    all_tankas = '短歌'
    all_tankas = '全体' if user_signed_in?
    all_tankas
  end

  def notifications
    notifications = Follow.where(user_id: current_user.id, read: false).count
    if notifications == 0
      nil
    else
      notifications
    end
  end

  def ruby(tanka)
    sanitize(tanka, tags: %w[ruby rp rt], attributes: %w[])
  end
end
