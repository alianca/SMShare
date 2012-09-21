# -*- coding: utf-8 -*-

require 'nokogiri'

class AuthorizationsController < ApplicationController
  respond_to :html
  before_filter :fetch_file, :only => [:new, :show]
  skip_before_filter :verify_authenticity_token, :only => [:create]
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
    logger.info "Authorized: #{client_ip}"
    url = Authorization.url_for(params[:code].downcase, @file, ip)
    unless url.nil?
      save_download_info
    end

    render :json => {:url => url}
  rescue Exception => err
    logger.error "Error: #{err}"
    render :json => {:url => nil}
  end

  def create
    xml = Nokogiri::XML.fragment(request.body.read.downcase)
    render :text => Authorization.register {
      :pin        => xml.at('pin').text,
      :value      => xml.at('pricepoint').text,
      :msisdn     => xml.at('msisdn').text,
      :carrier_id => xml.at('carrier_id').text
    }
  end

  private

  def client_ip
    request.headers["HTTP_X_FORWARDED_FOR"]
  end

  def fetch_file
    @file = UserFile.find(params[:file_id])
  end

  def save_download_info
    logger.info "IP: #{client_ip}"
    Download.create(:file => @file, :downloaded_by_ip => client_ip)
    @file.save
  end

end
