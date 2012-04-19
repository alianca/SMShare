class RegistrationsController < Devise::RegistrationsController
  respond_to :html
  prepend_view_path "app/views/devise"

  after_filter :generate_references, :only => [:create]

  layout :choose_layout

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

  private
    def choose_layout
      if ['edit', 'update'].include? action_name
        "user_panel"
      else
        "application"
      end
    end

    def generate_references
      current_user.set_referred cookies[:referred_user], cookies[:referred_banner]
    end
end
