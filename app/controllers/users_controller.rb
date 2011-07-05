class UsersController < ApplicationController
  before_filter :fetch_user, :only => [:show, :edit, :configure, :update]
  
  layout "application"
  
  def show
    @profile = @user.profile
    @files = @user.files.paginate(:per_page => 10, :page => params[:page])
  end
  
  def edit
    
  end
  
  def configure
    render :configure, :layout => "user_panel"
  end
  
  def update
    if params[:user][:profile][:avatar]
      @user.profile.avatar.destroy
      @user.profile.create_avatar(params[:user][:profile].delete(:avatar))
    end
    @user.update_attributes(params[:user])
    
    if (@user.save)
      flash[:notice] = "As alterações do perfil foram salvas com sucesso."
    else
      flash[:error] = "As alterações não puderam ser salvas."
    end
    redirect_to :back
  end
  
  private
    def fetch_user
      @user = User.find(params[:id])
    end
end
