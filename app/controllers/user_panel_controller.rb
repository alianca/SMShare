class UserPanelController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  
  layout 'user_panel'  
  
  def show
    @file = UserFile.new
    @most_downloaded_files = current_user.files.order_by(:"statistics.downloads").limit(10).to_a.sort { |x, y| y.statistics.downloads <=> x.statistics.downloads }
  end  
  
  def manage
    @files = current_user.files.order_by(:name).paginate(:per_page => 10, :page => params[:page])
  end
  
  def destroy
    UserFile.where(:_id.in => (params[:files].collect { |id| BSON::ObjectId(id) })).destroy_all if params[:files]
    redirect_to :back
  end
end
