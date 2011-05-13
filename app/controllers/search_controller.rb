class SearchController < ApplicationController
  before_filter :set_active, :only => [:index, :show]

  def set_active
    @active_header_tab = :search
    @active_footer = :search_files
  end
    
  def index
    @files = UserFile.search(params[:q], :per_page => 10, :page => params[:page]) if params[:q]        
  end
  
  def show
    @file = UserFile.find(params[:id])
    @filetype = @file.resolve_filetype
    @comments = @file.comments.paginate(:per_page => 6, :page => params[:page])
  end
  
  def new_comment
    rate = params[:rate]
    if rate == nil
      rate = 0
    end
    
    file = UserFile.find(params[:id])
    file.add_comment(Comment.create(:rate => rate.to_i, :message => params[:message], :owner => current_user))
    
    redirect_to :back
  end
  
  def remove_comment
    comment = Comment.find(params[:comment])
    if comment.owner == current_user && comment.owner != nil
      file = UserFile.find(params[:id])
      file.remove_comment(comment)
      comment.destroy
    end
    
    redirect_to :back
  end
end

