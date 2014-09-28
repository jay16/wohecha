module TeasHelper
  def is_active(tea)
    params ||= {}
    params[:tea] && params[:tea].to_i == tea.id
  end
end
