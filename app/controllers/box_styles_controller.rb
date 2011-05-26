class BoxStylesController < ApplicationController
  
  def create
    current_user.box_styles << BoxStyle.create(params[:box_style])
    current_user.save
    redirect_to :back
  end
  
  def set_default
    current_user.default_style = current_user.box_styles.find(params[:style][:selected_style])
    current_user.save
    redirect_to :back
  end
  
end
