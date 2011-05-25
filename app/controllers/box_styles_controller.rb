class BoxStylesController < ApplicationController
  
  def create
    current_user.box_styles.create(params[:box_style])
    redirect_to :back
  end
  
end
