class PaymentRequestsController < ApplicationController
  respond_to :html
  
  before_filter :authenticate_user!
  before_filter :fetch_payment_requests
  
  layout "user_panel"
  
  def show
    respond_with(@payment_requests)
  end
  
  def create
    @payment_requests.create(params[:payment_request])
    respond_with(@payment_requests, :location => user_panel_payment_requests_path)
  end
  
  private
    def fetch_payment_requests
      @payment_requests = current_user.payment_requests.order_by(:request_month.desc)
    end
end
