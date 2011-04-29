class HomeController < ApplicationController
  def index
    @active_header_tab = :main
    @active_footer = :main
  end
end
