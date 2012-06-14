class BoxStylesController < ApplicationController
  def create
    current_user.box_styles.create(params[:box_style])
    redirect_to :back
  end

  def set_default
    begin
      current_user.default_style = BoxStyle.find(params[:style][:selected_style])
    rescue
      current_user.default_style = current_user.box_styles.find(params[:style][:selected_style])
    end
    begin
      current_user.default_box_image = BoxImage.find(current_user.default_style.box_background_image)
    rescue
      current_user.default_box_image = current_user.box_images.find(current_user.default_style.box_background_image)
    end
    current_user.save
    redirect_to :back
  end

  def generate_javascript
    @style = params[:estilo]
    @background = params[:fundo]
    render :text => generate_javascript_data, :content_type => "text/javascript"
  end

  private
    def generate_javascript_data
      data = "var options = '"
      data += "?" if @style || @background
      data += "style=" + @style if @style
      data += "&" if @style && @background
      data += "background=" + @background if @background
      data += "';\n"
      file = File.open(Rails.root + "public/javascripts/jquery.js", "r");
      data += file.read
      file.close
      file = File.open(Rails.root + "public/javascripts/authorizations.js", "r");
      data += file.read # TODO fazer algum processamento antes?
      file.close

      data
    end
end
