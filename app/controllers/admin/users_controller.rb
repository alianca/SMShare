class Admin::UsersController < AdminController

  before_filter :fetch_user, :only => [:block, :unblock, :toggle_admin, :show]

  def index
    respond_with(@users = User.all)
  end

  def show
    respond_with(@user)
  end

  def block
    @user.blocked = true; @user.save!
    respond_with(@user, :location => admin_users_path)
  end

  def unblock
    @user.blocked = false; @user.save!
    respond_with(@user, :location => admin_users_path)
  end

  def toggle_admin
    @user.admin = !@user.admin?
    @user.save!
    respond_with(@user, :location => admin_users_path)
  end

  private

  def fetch_user
    @user = User.find(params[:id])
  end

end
