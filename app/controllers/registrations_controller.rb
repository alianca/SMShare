class RegistrationsController < Devise::RegistrationsController
  prepend_view_path "app/views/devise"

  def validate_field
    user = User.new(params[:user])
    user.valid?
        
    render :json => params[:user].keys.collect { |k| {k => user.errors[k].first} unless user.errors[k].first.blank? }.compact
  end
end