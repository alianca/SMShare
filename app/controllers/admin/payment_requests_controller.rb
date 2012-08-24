class Admin::PaymentRequestsController < AdminController
  def index
    respond_with(@completed = PaymentRequest.where(:status => :complete),
                 @pending = PaymentRequest.where(:status => :pending))
  end

  # Efetuar pagamentos
  def create
    err = PaymentRequest.send_payments_for_month(params[:month].to_i)

    unless err.empty?
      flash[:alert] = err.first
    end

    redirect_to :back
  end
end
