class SearchController < ApplicationController  
  before_filter :only => [:index, :show]

  def index
    @files = UserFile.search(params[:q]).paginate(:per_page => 10, :page => params[:page]) if params[:q]        
  end
  
end

