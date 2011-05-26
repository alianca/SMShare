class BoxImagesController < ApplicationController
  
  def create
    current_user.box_images << BoxImage.create(params[:background])
    current_user.save
    redirect_to :back
  end
end
