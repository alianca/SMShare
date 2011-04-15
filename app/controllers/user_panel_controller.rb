class UserPanelController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :fetch_folder, :only => [:create, :manage]
  
  layout 'user_panel'  
  
  def show
    @file = UserFile.new
    @most_downloaded_files = current_user.files.order_by(:"statistics.downloads").limit(10).to_a.sort { |x, y| (y.statistics.downloads || 0) <=> (x.statistics.downloads || 0) }
  end
  
  def create
    debugger
    @new_folder = @folder.children.create(:name => params[:folder][:name], :owner => current_user)
    respond_with(@new_folder, :location => manage_user_panel_path)
  end
  
  def manage
    @new_folder = @folder.children.new(:owner => current_user)
    @resources = @folder.paginate(params[:page], 10)
  end
  
  def destroy
    UserFile.where(:_id.in => (params[:files].collect { |id| BSON::ObjectId(id) })).destroy_all if params[:files]
    Folder.where(:_id.in => (params[:files].collect { |id| BSON::ObjectId(id) })).destroy_all if params[:files]
    redirect_to :back
  end
  
  private
    def fetch_folder
      if params[:folder_id]
        @folder = current_user.folders.find(params[:folder_id])
      else
        @folder = current_user.root_folder
      end
    end
end
