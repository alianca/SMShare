# -*- coding: utf-8 -*-
class AuthorizationsController < ApplicationController
  respond_to :html
  before_filter :fetch_file, :only => [:new, :show]

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

  def show
    begin
      @auth = Authorization.find params[:code]
      raise Error.new unless @auth
      url = @auth.url_for(@file, request.headers["X-Real-IP"])
      raise Error.new unless url
      redirect_to url
      @auth.destroy
    rescue
      render :file => File.join(Rails.root + 'public/404.html')
    end
  end

  def create
    @auth = Authorization.register params[:payment]
    render :nothing => true
    save_download_info
  end

  private

  def fetch_file
    @file = UserFile.find(params[:file_id])
  end

  def save_download_info
    Download.create(:file => @file, :downloaded_by_ip => request.headers["X-Real-IP"])
    @file.save
  end

end
