class AdvertisingController < ApplicationController
  before_filter :authenticate_user!
  layout 'user_panel'
  
  def show
    @references = current_user.references
    @total_clicks = @references.collect(&:clicks).sum
    @total_signups = @references.collect(&:signups).sum
    @total_comission = @references.collect(&:comission).sum
    @tab = params[:tab] || 'horizontals'
    @boxes = params[:boxes]
  end
  
  def create
    if current_user.references.create(params[:user_reference])
      flash[:notice] = "ID de referência criada com sucesso"
    else
      flash[:alert] = "ID de referência não pode ficar em branco"
    end
    
    redirect_to :back
  end
end
