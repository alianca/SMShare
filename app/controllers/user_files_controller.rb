class UserFilesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, :only => [:new, :create, :categorize, :update, :links]
  after_filter :save_download_info, :only => [:download]
  
  layout "user_panel", :except => [:show]
  
  
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
    respond_with(@files = current_user.files.find(params[:files]))
  end
  
  def remote_upload
    respond_with(@file = UserFile.new)
  end
  
  def categorize
    respond_with(@files = current_user.files.find(params[:files]))
  end
  
  # def create # FIXME I'm too fat. need a lypo.
  #   @files = []
  #   
  #   debugger
  #   
  #   for i in 0..params[:files].count-1
  #     puts params[:files][i.to_s]
  #     file = current_user.files.create(params[:files][i.to_s])
  #     @files << file if file.valid?
  #   end
  #   
  #   if !@files.empty?
  #     flash[:notice] = "Arquivo(s) enviado(s) com sucesso."
  #     respond_with(@files, :location => categorize_user_files_path(:files => @files))
  #   else
  #     flash[:alert] = file.errors.full_messages.first
  #     redirect_to :back
  #   end    
  # end
  
  def create
    @file = current_user.files.create(params[:user_file])
    flash[:notice] = "Arquivo enviado com sucesso." if @file.valid?
    flash[:alert] = @file.errors.full_messages.first unless @file.valid?    
    respond_with(@file, :location => categorize_user_files_path(:files => [@file]))
  end
  
  def update_categories
    @files = params[:files].collect do |file_id, file_params|
      file = UserFile.find(file_id)      
      file.category_ids = file_params[:categories].delete_if { |c| c.blank? }.collect { |c| BSON::ObjectId(c) }
      file.sentenced_tags = file_params[:sentenced_tags]
      file.save ? file : nil
    end.compact
    
    respond_with(@file, :location => links_user_files_path(:files => @files))
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
end
