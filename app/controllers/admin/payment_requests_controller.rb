class Admin::PaymentRequestsController < AdminController
  def index
    respond_with(@completed = PaymentRequest.where(:status => :complete),
                 @pending = PaymentRequest.where(:status => :pending))
  end

  # Efetuar pagamentos
  def create
    PaymentRequest.send_payments_for_month(params[:month])
    redirect_to :back
  end
end
