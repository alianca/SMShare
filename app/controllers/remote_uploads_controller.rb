class RemoteUploadsController < ApplicationController
  layout 'user_panel'

  def new
    @file = UserFile.new
  end

  def create
    f = current_user.files.create params[:user_file]
    if f.save
      redirect_to categorize_user_files_path(:files => [f._id])
    else
      flash[:alert] = "Erro ao criar arquivo remoto."
      redirect_to :back
    end
  end

end
