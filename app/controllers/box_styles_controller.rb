# -*- coding: utf-8 -*-
class BoxStylesController < ApplicationController

  def create
    current_user.box_styles.create(params[:box_style])
    redirect_to :back
  end

  def set_default
    current_user.default_box_style = fetch_box_style
    current_user.save!
    flash[:notice] = "Estilo padrão alterado com sucesso."
  rescue StandardError => e
    flash[:alert] = "Não foi possível alterar estilo padrão."
    logger.error e.to_s
  ensure
    redirect_to :back
  end

  def generate_javascript
    @style = params[:estilo]
    @background = params[:fundo]
    render :text => generate_javascript_data, :content_type => "text/javascript"
  end

  private

  def generate_javascript_data
    opt = {}
    opt[:style] = @style if @style
    opt[:background] = @background if @background
    %~var options = '#{opt.map{|p| p.join('=')}.join('&')}';
      #{File.read(Rails.root + "public/javascripts/jquery.js")}
      #{File.read(Rails.root + "public/javascripts/downbox.js")}
     ~
  end

  def fetch_box_style
    id = params[:style][:selected_style]
    begin
      BoxStyle.find id
    rescue
      current_user.box_styles.find id
    end
  end

end
