module SearchHelper  
  def search_pagination_info collection, search_term
        if collection.total_pages < 2
          case collection.size
          when 0; "Nenhum arquivo encontrado para '#{search_term}'".html_safe
          when 1; "Mostrando <b>1</b> arquivo para '#{search_term}'".html_safe
          else;   "Mostrando <b>todos os #{collection.size}</b> arquivos para '#{search_term}'".html_safe
          end
        else
          (%{Monstrando arquivos <b>%d&nbsp;-&nbsp;%d</b> de <b>%d</b> para '#{search_term}'} % [
            collection.offset + 1,
            collection.offset + collection.length,
            collection.total_entries
          ]).html_safe
        end
      end
end
