class SearchController < ApplicationController

  before_filter :set_active, :only => [:index, :show]

  def set_active
    @active_header_tab = :search
    @active_footer = :search_files
  end
  
  def index
    if params[:q]
      case params[:order]
      when 'download_count'
        order = 'downloads.count'
      when 'comment_count'
        order = 'comments.count'
      when 'rate'
        order = 'rate'
      else
        order = 'created_at'
      end
      
      all_files = UserFile.search(params[:q]).order_by([[order, :desc], [:alias, :asc]]).to_a
      
      if params[:filter]
        all_files.delete_if { |f| (f.categories.select { |c| c._id == BSON::ObjectId(params[:filter]) }).empty? }
      end
      
      @files = all_files.paginate(:per_page => 10, :page => params[:page])
    end
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

