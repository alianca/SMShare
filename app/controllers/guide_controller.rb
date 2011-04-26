class GuideController < ApplicationController
  def index
    @active_header_tab = :about
    @active_footer = :guide
  end

end
