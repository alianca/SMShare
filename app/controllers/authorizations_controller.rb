# -*- coding: utf-8 -*-
class AuthorizationsController < ApplicationController
  respond_to :html
  before_filter :get_remote_ip

  def new
#    if Authorization.is_valid?(params[:file_id], @remote_ip)
#      redirect_to(authorization_path(params[:file_id]))
#    else
      # Cabeçalhos necessários para o Cross Origin Resource Sharing
      headers['Access-Control-Allow-Methods'] = 'GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'x-requested-with'
      headers['Access-Control-Allow-Origin'] = '*'
      @file = UserFile.find(params[:file_id])
      @style = params[:style] ? BoxStyle.find(params[:style]) : (@file ? @file.owner.default_style : BoxStyle.default)
      @background = params[:background] ? BoxImage.find(params[:background]) : (@file ? @file.owner.default_box_image : BoxImage.default)
      respond_with(@file, :layout => nil)
#    end
  end

  def create
    # Authenticate with movile (params[:code])
    Authorization.create(params[:file_id], @remote_ip)
    redirect_to(authorization_path(params[:file_id]))
  end

  def show
    if Authorization.is_valid?(params[:id], @remote_ip)
      @file = UserFile.find(params[:id])
      redirect_to("#{@file.file.url}?filename=#{@file.alias}")
      save_download_info
    else
      raise ActionController::RoutingError.new('Not Found')
    end
  end

  private

  def save_download_info
    Download.create(:file => @file, :downloaded_by_ip => @remote_ip)
    @file.save
  end

  def get_remote_ip
    @remote_ip = request.env["REMOTE_ADDR"]
  end

end
