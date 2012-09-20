class FilesController < ApplicationController
  respond_to :html, :except => [:create]
  before_filter :authenticate_user!
  protect_from_forgery

  def new
    respond_with(@file = UserFile.new)
  end

  def create
    @file = current_user.files.create(params[:user_file].merge(params[:user_file][:file] || {}))
    if @file.save
      render :json => {:status => 'ok', :id => @file._id}
    else
      render :json => {:status => 'error', :reason => @file.errors.first}
    end
  end

end
