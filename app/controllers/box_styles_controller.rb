class BoxStylesController < ApplicationController
  def create
    current_user.box_styles.create(params[:box_style])
    redirect_to :back
  end
  
  def set_default
    current_user.default_style = BoxStyle.find(params[:style][:selected_style])
    current_user.save
    redirect_to :back
  end
  
  def generate_javascript
    style = params[:estilo]
    background = params[:fundo]
    data = generate_javascript_data(style, background)
    render :text => data, :content_type => "text/javascript"
  end
  
  private
    def generate_javascript_data style, background
      data = "var options = '"
      data += "?" if style || background
      data += "style=" + style if style
      data += "&" if style && background
      data += "background=" + background if background
      data += "';\n"
      file = File.open(Rails.root + "public/javascripts/jquery.js", "r");
      data += file.read
      file.close
      file = File.open(Rails.root + "public/javascripts/download_box.js", "r");
      data += file.read # TODO fazer algum processamento antes?
      file.close
      
      data
    end
end
