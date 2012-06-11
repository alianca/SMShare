# -*- coding: utf-8 -*-

class UserFilesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, :only => [:new, :create, :categorize, :update, :links]
  layout "user_panel", :except => [:show, :download_box]

  def new
    respond_with(@file = UserFile.new)
  end

  def show
    @file = UserFile.find(params[:id])
    @mime = @file.filetype
    @comment = Comment.new
    @owner = current_user._id == @file.owner._id
    @user_file_image = UserFileImage.new
    @comments = @file.comments.paginate(:per_page => 6, :page => params[:page])
    render(:show, :layout => 'application')
  end

  def links
    params[:files].delete_if { |f| f.blank? }
    respond_with(@files = current_user.files.find(params[:files]))
  end

  def remote_upload
    respond_with(@file = UserFile.new)
  end

  def remote_uploads
      UserFile.store_from_url(params[:user_file])
  end

  def categorize
    params[:files].delete_if { |f| f.blank? }
    respond_with(@files = current_user.files.find(params[:files]))
  end

  def create
    @file = current_user.files.create(params[:user_file].merge(params[:user_file][:file]))
    if @file.save and @file.valid?
      flash[:notice] = "Arquivo enviado com sucesso."
      respond_with(@file, :location => categorize_user_files_path(:files => [@file]))
    else
      flash[:alert] = @file.errors.full_messages.first
      redirect_to :back
    end
  end

  def update_categories
    @files = params[:files].collect do |file_id, file_params|
      file = UserFile.find(file_id)
      file.category_ids = file_params[:categories].
        delete_if{ |c| c.blank? }.
        collect{ |c| BSON::ObjectId(c) }
      file.sentenced_tags = file_params[:sentenced_tags]
      file.save! ? file : nil
    end.compact

    respond_with(@file, :location => links_user_files_path(:files => @files))
  end

end
