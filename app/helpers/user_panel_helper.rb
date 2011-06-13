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
    download_box_style @user_default_style
  end
  
  def download_box_style style
    {
      :box_background => style.box_background,
      :box_border => style.box_border,
      :header_background => style.header_background,
      :header_text => style.header_text,
      :upper_text => style.upper_text,
      :number_text => style.number_text,
      :para_text => style.para_text,
      :cost_text => style.cost_text,
      :form_background => style.form_background,
      :form_border => style.form_border,
      :form_text => style.form_text,
      :button_background => style.button_background,
      :button_text => style.button_text,
      :bottom_text => style.bottom_text
    }
  end
end
