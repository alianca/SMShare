module UserPanelHelper
  def filesize_for_stat stat, unit_class = "stat_unit"
    filesize, unit = number_to_human_size(stat).split(" ")
    "#{filesize}<span class=\"#{unit_class}\">#{unit}</span>".html_safe
  end
  
  def revenue_for_stat stat, unit_class = "stat_unit"
    number_to_currency(@user_statistics.revenue, :format => "<span class=\"#{unit_class}\">R$</span>%n").html_safe
  end
end
