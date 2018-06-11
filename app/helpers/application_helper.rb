module ApplicationHelper
  def title
    title = 'Utakata'
    if @title.present?
      title = @title + ' - Utakata'
    end
    title
  end

  def search_word(search)
    search_word = '全件表示'
    if search.present?
      search_word = '「' + search + '」で検索'
    end
    search_word
  end

  def all_tankas
    all_tankas = '短歌'
    if user_signed_in?
      all_tankas = '全体'
    end
    all_tankas
  end
end
