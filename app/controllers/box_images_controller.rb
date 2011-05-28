class BoxImagesController < ApplicationController
  def create
    current_user.box_images.create(params[:background])
    redirect_to :back
  end
  
  def set_default
    current_user.default_box_image = BoxImage.find(params[:bg][:selected_bg])
    current_user.save
    redirect_to :back
  end
end
