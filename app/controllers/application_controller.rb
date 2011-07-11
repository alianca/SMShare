class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  
  private
    def require_admin!
      authenticate_user!
      redirect_to new_user_session_path unless current_user.admin?
    end
    
    def after_sign_in_path_for(resource_or_scope)
      if resource_or_scope.is_a?(User)
        user_panel_path
      else
        super
      end
    end
  
end

