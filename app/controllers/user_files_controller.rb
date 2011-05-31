class UserFilesController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!, :only => [:new, :create, :categorize, :update, :links]
  after_filter :save_download_info, :only => [:download]
  
  layout "user_panel", :except => [:show]
  layout "application", :only => [:show]
  
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
  
  def create # FIXME I'm too fat. need a lypo.
    @files = []
    
    for i in 0..params[:files].count-1
      puts params[:files][i.to_s]
      file = current_user.files.create(params[:files][i.to_s])
      @files << file if file.valid?
    end
    
    if !@files.empty?
      flash[:notice] = "Arquivo(s) enviado(s) com sucesso."
      respond_with(@files, :location => categorize_user_files_path(:files => @files))
    else
      flash[:alert] = file.errors.full_messages.first
      redirect_to :back
    end
  end
  
  def update_categories # FIXME I'm too fat. need a lypo.
    @files = []
    
    params[:files].each do |file|
      file[1][:categories].delete_if { |c| c.blank? }
      the_file = UserFile.find(BSON::ObjectId(file[0]))
      file[1][:categories].each do |c|
        the_file.categories << Category.find(BSON::ObjectId(c))
      end
      
      the_file.sentenced_tags = file[1][:sentenced_tags]
      the_file.save
      @files << the_file
    end
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
    @file = UserFile.find(params[:id])
    @style = BoxStyle.find(params[:style]) if params[:style]
    @style = @item.owner.default_style unless params[:style]
    @background = BoxImage.find(params[:background]) if params[:background]
    @background = @item.owner.current_user.default_box_image unless params[:background]
    respond_with(@file, :layout => nil)
  end
  
  private
    def save_download_info
      Download.create(:file => @file, :downloaded_by_ip => request.env['REMOTE_ADDR'])
      @file.save
    end
end
