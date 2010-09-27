class HomeController < ApplicationController
  def index
    redirect_to user_panel_path if user_signed_in?
  end
end
