module UserPanelHelper
  def filesize_for_stat stat, unit_class = "stat_unit"
    filesize, unit = number_to_human_size(stat).split(" ")
    "#{filesize}<span class=\"#{unit_class}\">#{unit}</span>".html_safe
  end

  def revenue_for_stat stat, unit_class = "stat_unit"
    number_to_currency(stat / 10.0 || 0, :format => "<span class=\"#{unit_class}\">R$</span>%n").html_safe
  end

  def folders_to_move
    folders = @folder.parent ? [["..", @folder.parent._id]] : []
    folders += @folder.children.collect { |f| [f.name, f._id] }
  end

  def default_box_style
    @user_default_style
  end
end
