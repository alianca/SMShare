class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  private
    def require_admin!
      authenticate_user!
      redirect_to new_user_session unless current_user.is_admin?
    end
  
end
