# -*- coding: utf-8 -*-

class UserFilesController < ApplicationController
  respond_to :html, :except => [:create, :remote]
  before_filter :authenticate_user!, :except => [:show, :create, :remote]
  before_filter :require_admin!, :only => [:new]
  protect_from_forgery :except => [:create, :remote]
  layout "user_panel", :except => [:show, :create, :remote]

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
    @user = User.find(params[:user_id])
    @file = @user.files.create(params[:user_file].merge(params[:user_file][:file] || {}))
    if @file.save
      render :json => {:status => 'ok', :id => @file._id}
    else
      render :json => {:status => 'error', :reason => @file.errors.first}
    end
  end

  def remote
    create
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
