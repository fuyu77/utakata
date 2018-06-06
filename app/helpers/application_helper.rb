module ApplicationHelper
  def title
    title = 'Utakata'
    if @title.present?
      title = @title + ' - Utakata'
    end
    title
  end
end
