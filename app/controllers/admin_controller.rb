class AdminController < ApplicationController
  respond_to :html
  before_filter :require_admin!
  
  layout "admin"
end
