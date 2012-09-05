# -*- coding: utf-8 -*-

class UserFilesController < FilesController
  respond_to :html
  before_filter :authenticate_user!, :except => [:show]
  layout "user_panel", :except => [:show]

  def show
    @file = UserFile.find(params[:id])
    @mime = @file.filetype
    @comment = Comment.new
    @owner = current_user._id == @file.owner._id
    @user_file_image = UserFileImage.new
    @comments = @file.comments.to_a.delete_if{|c| c.blocked?}.paginate(:per_page => 6, :page => params[:page])
    render(:show, :layout => 'application')
  end

  def links
    params[:files].delete_if{ |f| f.blank? }
    respond_with(@files = current_user.files.find(params[:files]))
  end

  def categorize
    unless params[:files].blank?
      params[:files].delete_if{ |f| f.blank? }
      respond_with(@files = current_user.files.find(params[:files]))
    else
      redirect_to :back
    end
  end

  def update_categories
    @files = params[:user_files].collect do |file_id, file_params|
      file = UserFile.find(file_id)
      unless file_params[:categories].nil?
        file.category_ids = file_params[:categories].
          delete_if{ |c| c.blank? }.
          collect{ |c| BSON::ObjectId(c) }
      end
      file.sentenced_tags = file_params[:sentenced_tags]
      file.save! ? file : nil
    end.compact

    respond_with(@file, :location => links_user_files_path(:files => @files))
  end

end
