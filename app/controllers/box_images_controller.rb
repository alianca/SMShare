class BoxImagesController < ApplicationController
  def create
    current_user.box_images.create(params[:background])
    redirect_to :back
  end
  
  def set_default 
    current_user.default_box_image = current_user.box_images.find(params[:bg][:selected_bg])
    redirect_to :back
  end
end
