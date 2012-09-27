module AdvantagesHelper
  def icon sym
    "<img src=\"images/advantages/#{sym.to_s}.png\" alt=\"#{sym.to_s}\"/>".html_safe
  end
end
