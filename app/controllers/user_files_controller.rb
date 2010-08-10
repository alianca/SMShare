class UserFilesController < ApplicationController
  respond_to :html
  
  def new
    respond_with(@file = UserFile.new)
  end
  
  def create
    respond_with(@file = current_user.files.create(params[:user_file]))
  end
end
