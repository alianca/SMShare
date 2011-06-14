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
    # Cabeçalhos necessários para o Cross Origin Resource Sharing
    headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'x-requested-with'
    headers['Access-Control-Allow-Origin'] = '*'
    @file = UserFile.find(params[:id])
    @style = BoxStyle.find(params[:style]) if params[:style]
    @style = @file.owner.default_style unless params[:style]
    @background = BoxImage.find(params[:background]) if params[:background]
    @background = @file.owner.default_box_image unless params[:background]
    respond_with(@file, :layout => nil)
  end
  
  private
    def save_download_info
      Download.create(:file => @file, :downloaded_by_ip => request.env['REMOTE_ADDR'])
      @file.save
    end
end
