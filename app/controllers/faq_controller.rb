class FaqController < ApplicationController
  def index
    @page = params[:page] ? params[:page] : "general"
  end
end
