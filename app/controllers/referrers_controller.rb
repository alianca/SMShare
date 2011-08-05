class ReferrersController < ApplicationController
  before_filter :authenticate_user!
  layout 'user_panel'
  
  def show
    @referred = current_user.referred
  end
end
