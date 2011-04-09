class UserPanelController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  
  layout 'user_panel'  
  
  def show
    @file = UserFile.new
    @most_downloaded_files = current_user.files.order_by(:"statistics.downloads").limit(10).to_a.sort { |x, y| (y.statistics.downloads || 0) <=> (x.statistics.downloads || 0) }
  end
  
  def manage
    if params[:id] =~ /\/?([^\/]*)$/
      debugger
      @folder = current_user.folders.where(:path => "/#{params[:id].gsub($1, "")}", :id => BSON::ObjectId($1)).first
    else
      @folder = current_user.root_folder
    end
    
    @resources = @folder.paginate(params[:page], 10)
  end
  
  def destroy
    UserFile.where(:_id.in => (params[:files].collect { |id| BSON::ObjectId(id) })).destroy_all if params[:files]
    redirect_to :back
  end
end
