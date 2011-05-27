class SearchController < ApplicationController  
  before_filter :set_active, :only => [:index, :show]

  def index
    @files = UserFile.search(params[:q], :per_page => 10, :page => params[:page]) if params[:q]
  end
  
  private
    def set_active
      @active_header_tab = :search
      @active_footer = :search_files
    end
end

