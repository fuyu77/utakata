module ApplicationHelper
  def title
    title = 'Utakata'
    if @title
      title = @title + ' - Utakata'
    end
    title
  end
end
