# -*- coding: utf-8 -*-

require 'nokogiri'

class AuthorizationsController < ApplicationController
  respond_to :html
  before_filter :fetch_file, {
    :only => [:new, :show]
  }
  skip_before_filter :verify_authenticity_token, {
    :only => [:create]
  }
  layout 'authorizations', :only => [:new]

  def new
    if params[:style]
      @style = BoxStyle.find(params[:style])
    elsif @file
      @style = @file.owner.default_box_style
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

    respond_with(@file)
  end

  def show
    ip = client_ip
    url = Authorization.url_for(params[:code], @file, ip)
    save_download_info unless url.nil?
    render :json => {:url => url}
  end

  def create
    text = request.body.read
    xml = Nokogiri::XML.fragment(text)
    logger.info "XML: #{text}"
    error_code = Authorization.register(
      :pin        => xml.at('PIN').text,
      :value      => xml.at('PRICEPOINT').text,
      :msisdn     => xml.at('MSISDN').text,
      :carrier_id => xml.at('CARRIER_ID').text
    )
    logger.info(error_code == "1" ? "Sucesso." : "Falha.")
    render :text => error_code 
  end

  private

  def client_ip
    request.headers["HTTP_X_FORWARDED_FOR"]
  end

  def fetch_file
    @file = UserFile.find(params[:file_id])
  end

  def save_download_info
    Download.create(
      :file => @file,
      :downloaded_by_ip => client_ip
    )
    @file.save
  end

end
