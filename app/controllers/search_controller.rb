class SearchController < ApplicationController
  def index
    @files = UserFile.search(params[:q]).paginate(:per_page => 10, :page => params[:page]) if params[:q]
    @active_header_tab = :search
    @active_footer = :search_files
  end
  
  def show
    @file = UserFile.find(params[:id])
    @filetype = @file.resolve_filetype
    @comments = @file.comments.paginate(:per_page => 7, :page => params[:page])
    @images = []
  end
  
  def new_comment
    rate = params[:rate]
    if rate == nil
      rate = 0
    end
    
    file = UserFile.find(params[:id])
    file.comments << Comment.create(:rate => rate, :message => params[:message], :owner => current_user)
    file.save
    
    if rate.to_i > 0
      file.add_rate rate.to_i
    end
    
    redirect_to :back
  end
end

