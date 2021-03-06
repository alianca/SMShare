# -*- coding: utf-8 -*-
class UsersController < ApplicationController
  before_filter :fetch_user, :only => [:show, :edit, :update]
  before_filter :catch_trespassers!, :only => [:update, :change_password]
  before_filter :authenticate_user!, :except => [:show]

  layout "application"

  def show
    @profile = @user.profile
    @profile.has_been_seen
    @files = UserFile.for_user @user._id
  end

  def edit
    render :edit, :layout => "user_panel"
  end

  def update
    @user.update_attributes(params[:user])

    if (@user.profile.save and @user.save)
      flash[:notice] = "As alterações do perfil foram salvas com sucesso."
    else
      flash[:alert] = @user.errors.first
    end
    redirect_to :back
  end

  def change_password
    ok = false
    if params[:user][:password][:new_password].blank?
      @user.update_attributes(params[:user])
      ok = @user.save!
    elsif params[:user][:password][:new_password] ==
        params[:user][:password][:confirm_password]
      ok = @user.update_with_password params[:user]
    end
    if ok
      flash[:notice] = "Alterações salvas com successo."
    else
      flash[:alert] = "As alterações não puderam ser salvas."
    end
    redirect_to :back
  end

  private
    def fetch_user
      @user = User.find(params[:id])
    end

    def catch_trespassers!
      if params[:admin]
        flash[:alert] = "Boa tentativa, espertalhão..."
        redirect_to root_path
      end
    end
end
