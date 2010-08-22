class UserFilesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, :only => [:new, :create]
  
  layout 'user_panel', :only => [:new, :create]
  
  def new
    respond_with(@file = UserFile.new)
  end
  
  def create
    @file = current_user.files.create(params[:user_file])
    flash[:notice] = "Arquivo enviado com sucesso." if @file.valid?
    flash[:alert] = @file.errors.full_messages.first unless @file.valid?    
    respond_with(@file)
  end
  
  def example
    respond_with(@file = UserFile.find(params[:id]), :layout => nil)
  end
  
  def download_box
    respond_with(@file = UserFile.find(params[:id]), :layout => nil)
  end
end
