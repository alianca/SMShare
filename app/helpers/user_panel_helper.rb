module UserPanelHelper
  def filesize_for_stat stat, unit_class = "stat_unit"
    filesize, unit = number_to_human_size(stat).split(" ")
    "#{filesize}<span class=\"#{unit_class}\">#{unit}</span>".html_safe
  end
  
  def revenue_for_stat stat, unit_class = "stat_unit"
    number_to_currency(@user_statistics.revenue || 0, :format => "<span class=\"#{unit_class}\">R$</span>%n").html_safe
  end
  
  def folders_to_move
    folders = @folder.parent ? [["..", @folder.parent._id]] : []
    folders += @folder.children.collect { |f| [f.name, f._id] }
  end
  
  def default_box_style
    download_box_style @default_style
  end
  
  def download_box_style style
    {
      :box_image => style ? style.box_image : "/images/download_box/fundo_padrao.png",
      :box_background => style ? style.box_background : "#FFFFFF",
      :box_border => style ? style.box_border : "#5596AC",
      :header_background => style ? style.header_background : "#5596AC",
      :header_text => style ? style.header_text : "#FFFFFF",
      :upper_text => style ? style.upper_text : "#1D4E5D",
      :number_text => style ? style.number_text : "#5596AC",
      :para_text => style ? style.para_text : "#676568",
      :cost_text => style ? style.cost_text : "9C9E9D",
      :form_background => style ? style.form_background : "#FFFFFF",
      :form_border => style ? style.form_border : "#7BBACF",
      :form_text => style ? style.form_text : "#8E8E8E",
      :button_background => style ? style.button_background : "#F27F00",
      :button_text => style ? style.button_text : "#FFFFFF",
      :bottom_text => style ? style.bottom_text : "#5596AC"
    }
  end
end
