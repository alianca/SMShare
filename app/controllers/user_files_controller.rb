class UserFilesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, :only => [:new, :create]
  
  layout 'user_panel', :only => [:new]
  
  def new
    respond_with(@file = UserFile.new)
  end
  
  def create    
    respond_with(@file = current_user.files.create(params[:user_file])) do |format|
      if @file.valid?
        flash[:notice] = "Arquivo enviado com sucesso."
      else
        flash[:alert] = @file.errors.full_messages.first
        format.html { render :action => :new, :layout => 'user_panel' }
      end
    end
  end
end
