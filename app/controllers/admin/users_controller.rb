class Admin::UsersController < AdminController
  def index
    respond_with(@users = User.all)
  end
  
  def show
    respond_with(@user = User.find(params[:id]))
  end  
  
  def block
    @user = User.find(params[:id])
    @user.blocked = true; @user.save!
    respond_with(@user, :location => admin_users_path)    
  end
  
  def unblock
    @user = User.find(params[:id])
    @user.blocked = false; @user.save!
    respond_with(@user, :location => admin_users_path)    
  end
end
