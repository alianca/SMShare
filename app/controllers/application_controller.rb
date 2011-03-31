class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  private
    def require_admin!
      authenticate_user!
      redirect_to new_user_session_path unless current_user.admin?
    end
  
end
