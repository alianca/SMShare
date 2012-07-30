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
    code = params[:code]
    ip = request.env["REMOTE_ADDR"]
    url = Authorization.url_for(code, @file, ip)
    raise :invalid_pin unless url
    @auth.destroy
    save_download_info
    render :json => { :url => url }
  rescue
    render :json => { :url => nil }
  end

  def create
    xml = Nokogiri::XML.fragment(request.body.read)
    @auth = Authorization.register(:pin => xml.at('pin').text,
                                   :msisdn => xml.at('msisdn').text,
                                   :carrier_id => xml.at('carrier_id').text)
    render :text => '1'
  rescue Exception => e
    render :text => "0 # #{e.message}"
  end

  private

  def fetch_file
    @file = UserFile.find(params[:file_id])
  end

  def save_download_info
    logger.info "IP: #{request.env['REMOTE_ADDR']}"
    Download.create(:file => @file, :downloaded_by_ip => request.env['REMOTE_ADDR'])
    @file.save
  end

end
