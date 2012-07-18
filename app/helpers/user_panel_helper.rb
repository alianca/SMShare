module UserPanelHelper
  require 'user_files_helper'

  def filesize_for_stat stat, unit_class = "stat_unit"
    filesize, unit = number_to_human_size(stat).split(" ")
    "#{filesize}<span class=\"#{unit_class}\">#{unit}</span>".html_safe
  end

  def revenue_for_stat stat, unit_class = "stat_unit"
    number_to_currency(stat || 0, :format => "<span class=\"#{unit_class}\">R$</span>%n").html_safe
  end

  def folders_to_move
    folders = @folder.parent ? [["..", @folder.parent._id]] : []
    folders += @folder.children.collect { |f| [f.name, f._id] }
  end

  def default_box_style
    @user_default_style
  end

  def toolbar_button(label, name, options = "")
    %$<li class="#{name}">
        #{link_to '', '#', :class => 'icon ' + options, :action => name}
        #{link_to label, '#', :class => options, :action => name}
      </li>
     $.html_safe
  end
end
