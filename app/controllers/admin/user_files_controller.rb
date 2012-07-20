class Admin::UserFilesController < AdminController
  def index
    respond_with(@files = UserFile.all)
  end

  def show
    respond_with(@file = UserFile.find(params[:id]))
  end

  def block
    @file = UserFile.find(params[:id])
    @file.blocked = true; @file.save!
    redirect_to :back
  end

  def unblock
    @file = UserFile.find(params[:id])
    @file.blocked = false; @file.save!
    redirect_to :back
  end
end
