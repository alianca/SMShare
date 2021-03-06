module SearchHelper
  def search_pagination_info collection, search_term
    if collection.total_pages < 2
      case collection.size
      when 0; "Nenhum arquivo encontrado para '#{search_term}'".html_safe
      when 1; "Mostrando <b>1</b> arquivo para '#{search_term}'".html_safe
      else;   "Mostrando <b>todos os #{collection.size}</b> arquivos para '#{search_term}'".html_safe
      end
    else
      (%{Mostrando arquivos <b>%d&nbsp;-&nbsp;%d</b> de <b>%d</b> para '#{search_term}'} % [
        (collection.current_page-1) * collection.per_page + 1,
        (collection.current_page-1) * collection.per_page + collection.count,
        collection.count
      ]).html_safe
    end
  end

  def result_for_search_item search_item
    #search_item.class.find(search_item.id)
  end
end
