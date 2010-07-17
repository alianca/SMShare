module ApplicationHelper
  # Retorna qual stylesheet ou javascript carregar para um dado controller
  def stylesheet_for_controller
    params[:controller].sub("devise/", "")
  end
  alias_method :javascript_for_controller, :stylesheet_for_controller
  
  # Define o titulo a ser mostrado pelo layout
  def title a_title = nil
    content_for :title, a_title
  end
  
  # Cria um tag de titulo com o titulo definido ou um padrão
  def title_tag default_title = ""
    content_tag :title, content_for?(:title) ? @_content_for[:title] : default_title
  end
end
