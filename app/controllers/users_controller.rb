class UsersController < ApplicationController
  before_filter :fetch_user, :only => [:show, :edit, :update]
  before_filter :authenticate_user!
  
  layout "application"
  
  def show
    @profile = @user.profile
    @files = @user.files.paginate(:per_page => 10, :page => params[:page])
  end
  
  def edit
    render :edit, :layout => "user_panel"
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
      flash[:alert] = "As alterações não puderam ser salvas."
    end
    redirect_to :back
  end
  
  def change_password
    ok = false
    if params[:user][:password][:new_password].blank?
      @user.update_attributes(params[:user])
      ok = @user.save!
    elsif params[:user][:password][:new_password] == params[:user][:password][:confirm_password]
      ok = @user.update_with_password params[:user]
    end
    if ok
      flash[:notice] = "Alterações salvas com successo."
    else
      flash[:alert] = "As alterações não puderam ser salvas."
    end
    
    redirect_to :back
  end
  
  def states_for_country
    begin
      @states = Carmen::states(params[:country])
    rescue
      @states = []
    end
    render :json => @states.to_json
  end
  
  private
    def fetch_user
      @user = User.find(params[:id])
    end
end
