# -*- coding: utf-8 -*-
class AuthorizationsController < ApplicationController
  respond_to :html
  after_filter :save_download_info, :only => :create
  before_filter :fetch_file, :only => [:new, :create]

  def new
    # Cabeçalhos necessários para o Cross Origin Resource Sharing
    headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'x-requested-with'
    headers['Access-Control-Allow-Origin'] = '*'

    if params[:style]
      @style = BoxStyle.find(params[:style])
    elsif @file
      @style = @file.owner.default_style
    else
      @style = BoxStyle.default
    end

    if params[:background]
      @background = BoxImage.find(params[:background])
    elsif @file
      @background = @file.owner.default_box_image
    else
      BoxImage.default
    end

    respond_with(@file, :layout => nil)
  end

  def create
    @auth = Authorization.new params[:code], {
      :file_id => @file._id,
      :address => request.headers["X-Real-IP"]
    }
    # Send code to movile
    render :json => {:id => @auth.id}
  end

  def activate
    @auth = Authorization.find(params[:pin])
    unless @auth.nil?
      @auth.activate(params)
    end
    render :nothing => true
  end

  def check
    @auth = Authorization.find(params[:id])
    render :json => { :url => @auth.url }
    @auth.destroy if @auth.url?
  end

  private

  def fetch_file
    @file = UserFile.find(params[:file_id])
  end

  def save_download_info
    Download.create(:file => @file, :downloaded_by_ip => request.env["X-Real-IP"])
    @file.save
  end

end
