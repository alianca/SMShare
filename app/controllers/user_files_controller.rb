# -*- coding: utf-8 -*-

class UserFilesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, :only =>
    [:new, :create, :categorize, :update, :links]
  after_filter :save_download_info, :only => [:download]

  layout "user_panel", :except => [:show, :download_box]

  def new
    respond_with(@file = UserFile.new)
  end

  def show
    @file = UserFile.find(params[:id])
    @filetype = @file.resolve_filetype
    @comment = Comment.new
    @comments = @file.comments.paginate(:per_page => 6, :page => params[:page])
    render(:show, :layout => 'application')
  end

  def links
    respond_with(@files = current_user.files.find(params[:files]))
  end

  def remote_upload
    respond_with(@file = UserFile.new)
  end

  def categorize
    respond_with(@files = current_user.files.find(params[:files]))
  end

  def create
    @file = current_user.files.create(params[:user_file])
    flash[:notice] = "Arquivo enviado com sucesso." if @file.valid?
    flash[:alert] = @file.errors.full_messages.first unless @file.valid?
    respond_with(@file, :location => categorize_user_files_path(:files => [@file]))
  end

  def download
    @file = UserFile.find(params[:id])
    redirect_to "#{@file.file.url}?filename=#{@file.alias}"
  end

  def update_categories
    @files = params[:files].collect do |file_id, file_params|
      file = UserFile.find(file_id)
      file.category_ids = file_params[:categories].delete_if { |c|
        c.blank? }.collect { |c| BSON::ObjectId(c) }
      file.sentenced_tags = file_params[:sentenced_tags]
      file.save ? file : nil
    end.compact

    respond_with(@file, :location => links_user_files_path(:files => @files))
  end

  def example
    respond_with(@file = UserFile.find(params[:id]), :layout => nil)
  end

  def download_box
    # Cabeçalhos necessários para o Cross Origin Resource Sharing
    headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'x-requested-with'
    headers['Access-Control-Allow-Origin'] = '*'
    if params[:id] =~ /^[a-f0-9]{24}$/ and !UserFile.where(:_id => BSON::ObjectId(params[:id])).empty?
      @file = UserFile.find(params[:id])
    end
    @style = params[:style] ? BoxStyle.find(params[:style]) : (@file ? @file.owner.default_style : BoxStyle.default)
    @background = params[:background] ? BoxImage.find(params[:background]) : (@file ? @file.owner.default_box_image : BoxImage.default)
    respond_with(@file, :layout => nil)
  end

  private
    def save_download_info
      Download.create(:file => @file, :downloaded_by_ip => request.env['REMOTE_ADDR'])
      @file.save
    end
end
