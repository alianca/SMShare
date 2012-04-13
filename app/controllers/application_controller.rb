class ApplicationController < ActionController::Base
  before_filter :save_reference!
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

  def save_reference!
    if params[:ref]
      cookies[:referred_user] = params[:ref]
      @referred_user = User.where(:nickname => params[:ref]).first
      if params[:ban]
        cookies[:referred_banner] = params[:ban]
        @referred_banner = @referred_user.references.where(:name => params[:ban]).first
        @referred_banner.got_click unless @referred_banner.user == @referred_user
      end
    end
  end
end
