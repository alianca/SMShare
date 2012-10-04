class BoxImagesController < ApplicationController
  def create
    image = current_user.box_images.create(params[:background])
    if image.valid?
      flash[:notice] = "Fundo criado com sucesso."
    else
      flash[:alert] = "Você deve dar um nome ao seu fundo."
    end
    redirect_to :back
  end

  def set_default
    current_user.default_box_image = BoxImage.find(params[:bg][:selected_bg])
    current_user.save
    redirect_to :back
  end
end
