# -*- coding: utf-8 -*-

class UserPanelController < ApplicationController
  respond_to :html
  before_filter :authenticate_user!
  before_filter :fetch_folder, :only => [
    :create,
    :manage,
    :compress
  ]

  layout 'user_panel'

  def show
    @file = UserFile.new
    @today_downloads = UserDailyStatistic.
      today_downloads_for current_user
    @today_referred_downloads = UserDailyStatistic.
      today_referred_downloads_for current_user
    @today_total_revenue = UserDailyStatistic.
      today_total_revenue_for current_user

    @yesterday_downloads = UserDailyStatistic.
      yesterday_downloads_for current_user
    @yesterday_referred_downloads = UserDailyStatistic.
      yesterday_referred_downloads_for current_user
    @yesterday_total_revenue = UserDailyStatistic.
      yesterday_total_revenue_for current_user

    @this_month_downloads = UserDailyStatistic.
      this_month_downloads_for current_user
    @this_month_referred_downloads = UserDailyStatistic.
      this_month_referred_downloads_for current_user
    @this_month_total_revenue = UserDailyStatistic.
      this_month_total_revenue_for current_user

    @last_month_downloads = UserDailyStatistic.
      last_month_downloads_for current_user
    @last_month_referred_downloads = UserDailyStatistic.
      last_month_referred_downloads_for current_user
    @last_month_total_revenue = UserDailyStatistic.
      last_month_total_revenue_for current_user

    @most_downloaded_files = current_user.files.
      order_by(:"statistics.downloads").limit(10).to_a
#    @most_downloaded_files.sort! { |x, y|
#      (y.statistics.downloads || 0) <=>
#      (x.statistics.downloads || 0)
#    }
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
    begin
      if params[:files]
        UserFile.where(:_id.in => (params[:files].map{ |id| BSON::ObjectId(id) })).destroy_all
        Folder.where(:_id.in => (params[:files].map{ |id| BSON::ObjectId(id) })).destroy_all
      end
      flash[:notice] = "Arquivos removidos com sucesso."
    rescue
      flash[:alert] = "Não foi possível remover os arquivos"
    end
    render :nothing => true
  end

  def move
    params[:user_file][:files].delete_if { |f| f.blank? }
    @folder = current_user.folders.find(params[:user_file][:folder])
    @files = UserFile.where(:_id.in => (params[:user_file][:files].map{ |id| BSON::ObjectId(id) }))
    @folders = Folder.where(:_id.in => ((params[:user_file][:files] - [params[:user_file][:folder]]).map{ |id| BSON::ObjectId(id) }))

    @files.each { |file| file.folder = @folder; file.save! }
    @folders.each { |folder| folder.parent = @folder; folder.save! }

    flash[:notice] = "Arquivos movidos com sucesso."
    respond_with(@folder, :location => manage_user_panel_path(:folder_id => @folder.parent))
  rescue
    flash[:alert] = "Não foi possível mover os arquivos."
    redirect_to :back
  end

  def rename
    ids = params[:user_file][:new_name].map{|p| BSON::ObjectId(p[0])}.compact
    files = UserFile.where(:_id.in => ids) + Folder.where(:_id.in => ids)
    files.each do |f|
      f.name = params[:user_file][:new_name][f.id.to_s]
      f.save!
    end
    flash[:notice] = "Arquivos renomeados com sucesso."
  rescue
    flash[:alert] = "Não foi possível renomear os arquivos."
  ensure
    redirect_to :back
  end

  def edit
    @file = UserFile.find(params[:file])
    @filetype = @file.resolve_filetype
    @comments = @file.comments.paginate(:per_page => 6, :page => params[:page])
  end

  def customize
    @styles = (BoxStyle.defaults + current_user.box_styles.all).uniq
    @default_style = current_user.default_box_style
    @backgrounds = (BoxImage.default_list + current_user.box_images.all).uniq
    @default_background = current_user.default_box_image
  end

  private

  def fetch_folder
    @folder = current_user.folders.find(params[:folder_id])
  rescue
    @folder = current_user.root_folder
  end

end
