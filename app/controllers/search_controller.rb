class SearchController < ApplicationController
  def index
    @files = UserFile.search(params[:q]).paginate(:per_page => 1, :page => params[:p]) if params[:q]
  end  
end
