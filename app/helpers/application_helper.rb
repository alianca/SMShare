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
  
  # Define a página atual
  def page a_page
    content_for :page, a_page
  end
  
  # Define a aba (principal) atual
  def tab a_tab
    content_for :tab, a_tab
  end
  
end
