class RegistrationsController < Devise::RegistrationsController
  prepend_view_path "app/views/devise"

  layout :choose_layout

  def edit
    @countries = Carmen.countries(:locale => :en, :default_country => @user.profile.country)
    begin
      @states = Carmen::states(@user.profile.country)
    rescue
      @states = []
    end
  end

  def create
    resource.referred_by = cookies[:referred_banner] if cookies[:referred_banner]

    if resource.save
      if cookies[:referred_user]
        @referred_user = User.where(:nickname => cookies[:referred_user]).first
        @referred_user.referred << resource
      end

      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_navigational_format?
        sign_in(resource_name, resource)
        respond_with resource, :location => after_sign_up_path_for(resource)
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        expire_session_data_after_sign_in!
        respond_with resource, :location => after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  def validate_field
    user = User.new(params[:user])
    user.valid?

    render :json => params[:user].keys.collect { |k| {k => user.errors[k].first} unless user.errors[k].first.blank? }.compact
  end

  private
    def choose_layout
      if ['edit', 'update'].include? action_name
        "user_panel"
      else
        "application"
      end
    end
end
