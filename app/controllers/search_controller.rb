class SearchController < ApplicationController
  
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

end

