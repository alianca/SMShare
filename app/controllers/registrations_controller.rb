# -*- coding: utf-8 -*-
class RegistrationsController < Devise::RegistrationsController
  respond_to :html
  prepend_view_path "app/views/devise"

  layout :choose_layout

  def edit
    @countries = Carmen.countries(:locale => :en,
                                  :default_country => @user.profile.country)
    begin
      @states = Carmen::states(@user.profile.country)
    rescue
      @states = []
    end
  end

  def validate_field
    user = User.new(params[:user])
    user.valid?

    render :json => params[:user].keys.collect { |k|
      {k => user.errors[k].first} unless user.errors[k].first.blank?
    }.compact
  end

  def create
    if params[:user][:admin]
      flash[:alert] = "Boa tentativa, espertalhão"
      redirect_to :back
    else
      super # completes registration and yields @user
      save_referred_signup!
    end
  end

  private

  def choose_layout
    if ['edit', 'update'].include? action_name
      "user_panel"
    else
      "application"
    end
  end

  def save_referred_signup!
    if cookies[:referred_user]
      referred_user = User.where(:nickname => cookies[:referred_user]).first
      referred_user.referred << @user
      referred_user.save
      @user.referred_by = cookies[:referred_banner]
      @user.save
      cookies.delete :referred_user
      cookies.delete :referred_banner
    end
  end

end
