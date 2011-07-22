class RegistrationsController < Devise::RegistrationsController
  prepend_view_path "app/views/devise"
  
  layout "application", :except => [:edit, :update]
  layout "user_panel", :only => [:edit, :update]
  
  def edit
    @countries = Carmen.countries(:locale => :en, :default_country => @user.profile.country)
    begin
      @states = Carmen::states(@user.profile.country)
    rescue
      @states = []
    end
  end
  
  def validate_field
    user = User.new(params[:user])
    user.valid?
    
    render :json => params[:user].keys.collect { |k| {k => user.errors[k].first} unless user.errors[k].first.blank? }.compact
  end
end

