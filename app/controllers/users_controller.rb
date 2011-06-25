class UsersController < ApplicationController
  before_filter :fetch_user, :only => [:show, :update, :update_configuration]

  layout "application"
  
  def show
    @profile = @user.profile
    @files = @user.files.paginate(:per_page => 10, :page => params[:page])
  end
  
  def update
    
  end
  
  def update_configuration
    @user.profile.update_attributes(params[:profile_configuration])
    flash[:notice] = "Opções do perfil foram salvas com sucesso."
  end
  
  private
    def fetch_user
      @user = User.find(params[:id])
end

