class Admin::PaymentRequestsController < AdminController
  def index
    respond_with(@payment_requests = PaymentRequest.all)
  end

  # Efetuar pagamentos
  def create
    PaymentRequest.send_payments_for_month(params[:month])
    redirect_to :back
  end
end
