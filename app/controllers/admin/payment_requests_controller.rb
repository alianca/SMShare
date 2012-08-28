class Admin::PaymentRequestsController < AdminController
  def index
    respond_with(@completed = PaymentRequest.completed,
                 @pending = PaymentRequest.pending)
  end

  # Efetuar pagamentos
  def create
    @requests = PaymentRequest.where(:_id.in => params[:requests])
    PaymentRequest.send_payments(@requests)
  rescue
    flash[:alert] = "Erro ao enviar as requisições de pagamento"
  ensure
    redirect_to :back
  end
end
