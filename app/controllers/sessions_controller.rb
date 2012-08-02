class SessionsController < Devise::SessionsController
  respond_to :html
  prepend_view_path 'app/views/devise'
  before_filter :store_last_page!, :only => [:create]

private

  def store_last_page!
    raise RedirectBackError unless
      session[:last_page] = request.headers["Referer"]
  end

end
