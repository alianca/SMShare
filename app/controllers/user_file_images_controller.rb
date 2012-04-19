# -*- coding: utf-8 -*-

class UserFileImagesController < ApplicationController
  def create
    file = UserFile.find(params[:user_file_image][:file])
    image = file.images.create(:image => params[:user_file_image][:image], :file => file) unless current_user != file.owner
    redirect_to :back
  end

  def destroy
    file = UserFile.find(params[:file_id])
    file.images.find(params[:id]).destroy unless current_user != file.owner
    redirect_to :back
  end
end
