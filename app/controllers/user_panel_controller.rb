class UserPanelController < ApplicationController
  layout 'user_panel'
  
  def show
    @file = UserFile.new
    @most_downloaded_files = current_user.files.order_by(:"statistics.downloads").limit(10)
  end  
end
