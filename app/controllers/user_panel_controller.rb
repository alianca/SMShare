class UserPanelController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :fetch_folder, :only => [:create, :manage]
  
  layout 'user_panel'  
  
  def show
    @file = UserFile.new
    @most_downloaded_files = current_user.files.order_by(:"statistics.downloads").limit(10).to_a.sort { |x, y| (y.statistics.downloads || 0) <=> (x.statistics.downloads || 0) }
  end
  
  def create
    @new_folder = @folder.children.create(:name => params[:folder][:name], :owner => current_user)
    respond_with(@new_folder, :location => manage_user_panel_path(:folder_id => @folder._id))
  end
  
  def manage
    @new_folder = @folder.children.new(:owner => current_user)
    @resources = @folder.paginate(params[:page], 10)
    @active = [:files, :manage]
    @active_footer = :manage_files
  end
  
  def destroy
    UserFile.where(:_id.in => (params[:files].collect { |id| BSON::ObjectId(id) })).destroy_all if params[:files]
    Folder.where(:_id.in => (params[:files].collect { |id| BSON::ObjectId(id) })).destroy_all if params[:files]
    redirect_to :back
  end
  
  def move
    params[:user_file][:files].delete_if { |f| f.blank? }
    @folder = current_user.folders.find(params[:user_file][:folder])
    @files = UserFile.where(:_id.in => (params[:user_file][:files].collect { |id| BSON::ObjectId(id) }))
    @folders = Folder.where(:_id.in => ((params[:user_file][:files]-[params[:user_file][:folder]]).collect { |id| BSON::ObjectId(id) }))
    
    @files.each { |file| file.folder = @folder; file.save! }
    @folders.each { |folder| folder.parent = @folder; folder.save! }
    
    respond_with(@folder, :location => manage_user_panel_path(:folder_id => @folder.parent))
  end
  
  def rename
    params[:user_file][:files].delete_if { |f| f.blank? }
    @files = UserFile.where(:_id.in => (params[:user_file][:files].collect { |id| BSON::ObjectId(id) }))
    @folders = Folder.where(:_id.in => ((params[:user_file][:files]-[params[:user_file][:folder]]).collect { |id| BSON::ObjectId(id) }))
    
    @files.each { |file| file.alias = params[:user_file][:new_name][file.id.to_s]; file.save! }
    @folders.each { |folder| folder.name = params[:user_file][:new_name][folder.id.to_s]; folder.save! }
    
    redirect_to :back
  end
  
  def edit
    @file = UserFile.find(params[:file])
    @filetype = @file.resolve_filetype
    @comments = @file.comments.paginate(:per_page => 6, :page => params[:page])
  end
  
  def customize
    @styles = current_user.box_styles
    @default_style = current_user.default_style
    #@backgrounds = current_user.box_backgrounds
  end
  
  private
    def fetch_folder
      if params[:folder_id]
        @folder = current_user.folders.find(params[:folder_id])
      else
        @folder = current_user.root_folder
      end
    end
end

