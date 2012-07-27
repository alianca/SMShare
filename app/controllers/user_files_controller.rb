# -*- coding: utf-8 -*-

class UserFilesController < ApplicationController
  respond_to :html, :except => [:create]
  before_filter :authenticate_user!, :except => [:show, :create]
  before_filter :require_admin!, :only => [:new]
  protect_from_forgery :except => :create
  layout "user_panel", :except => [:show, :create]

  def new
    respond_with(@file = UserFile.new)
  end

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

  def create
    @file = current_user.files.create(params[:user_file].merge(params[:user_file][:file] || {}))
    if @file.save and @file.valid?
      render :json => {:status => 'ok', :id => @file._id}
    else
      render :json => {:status => 'error'}
    end
  end

  def create_multi
    @files = JSON.parse(params[:files]).
      map{ |f| current_user.files.create(f) }.
      delete_if{ |f| !f.save }
    redirect_to categorize_user_files_path(:files => @files)
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
