class UserFilesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, :only => [:new, :create, :categorize, :update, :links]
  after_filter :save_download_info, :only => [:download]
  
  layout :choose_layout
   
  def new
    respond_with(@file = UserFile.new)
  end
  
  def show
    @file = UserFile.find(params[:id])
    @filetype = @file.resolve_filetype
    @comment = Comment.new
    @comments = @file.comments.paginate(:per_page => 6, :page => params[:page])
  end
  
  def links
    respond_with(@file = current_user.files.find(params[:id]))
  end
  
  def remote_upload
    respond_with(@file = UserFile.new)
  end
  
  def categorize
    respond_with(@files = current_user.files.find(params[:id]))
  end
  
  def create
    count = params[:user_files][:count]
    
    @files = []
    for i in 1..count.to_i
      file = current_user.files.create(params[:user_files]["user_file"+i.to_s])
      file.copy_filename # Copia o filename original para o alias
      flash[:notice] = "Arquivo enviado com sucesso." if file.valid?
      flash[:alert] = file.errors.full_messages.first unless file.valid?
      @files << file
    end
    respond_with(@files, :location => categorize_user_file_path(@files))
  end
  
  def update
    params[:user_file][:category_ids].delete_if { |c| c.blank? }
    
    @file = current_user.files.find(params[:id])
    @file.update_attributes(params[:user_file])
    
    respond_with(@file, :location => links_user_file_path(@file))
  end
  
  def example
    respond_with(@file = UserFile.find(params[:id]), :layout => nil)
  end
  
  def download
    begin
      @file = UserFile.find(params[:id])
      headers["Content-Disposition"] = "attachment; filename=\"#{@file.alias}\""
      render :text => @file.file.file.read, :content_type => @file.filetype
    rescue Mongoid::Errors::DocumentNotFound
      render :file => Rails.root + 'public/404.html', :status => 404
    end
  end
  
  def download_box
    respond_with(@file = UserFile.find(params[:id]), :layout => nil)
  end

  private
    def save_download_info
      Download.create(:file => @file, :downloaded_by_ip => request.env['REMOTE_ADDR'])
      @file.save
    end
    
    def choose_layout
      if ['new', 'create', 'remote_upload', 'categorize', 'links'].include? action_name
        'user_panel'
      elsif action_name == 'show'
        'application'
      end
    end
end
