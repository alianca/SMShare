class AdvertisingController < ApplicationController
  before_filter :authenticate_user!
  layout 'user_panel'

  def show
    @start_date = params[:start_date].blank? ? 30.days.ago.to_date : Date.strptime(params[:start_date], "%d/%m/%Y")
    @end_date  = params[:end_date].blank? ? Date.today : Date.strptime(params[:end_date], "%d/%m/%Y")
    @references = current_user.references.where(:created_at.in => (@start_date..@end_date).to_a)
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
