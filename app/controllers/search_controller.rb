class SearchController < ApplicationController
  def index
    @files = UserFile.search(params[:q]).paginate(:per_page => 10, :page => params[:page]) if params[:q]
    @active_header_tab = :search
    @active_footer = :search_files
  end  
end
