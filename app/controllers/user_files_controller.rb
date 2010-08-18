class UserFilesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, :only => [:new, :create]
  
  layout 'user_panel', :only => [:new]
  
  def new
    respond_with(@file = UserFile.new)
  end
  
  def create
    respond_with(@file = current_user.files.create(params[:user_file]))
  end
end
