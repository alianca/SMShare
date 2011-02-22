class SearchController < ApplicationController
  def index
    @files = UserFile.search params[:q] if params[:q]
  end  
end
