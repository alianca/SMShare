class PaymentRequestsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :fetch_payment_requests

  layout "user_panel", :except => []

  def show
    respond_with(@payment_requests)
  end

  def create
    current_user.payment_requests.create params[:payment_request].
      merge({
        :value              => current_user.statistics.
                                 revenue_available_for_payment,
        :downloads          => current_user.statistics.downloads,
        :referred_downloads => current_user.statistics.referred_downloads,
        :referred_value     => current_user.statistics.
                                 referred_revenue_available_for_payment
      })
    respond_with @payment_requests, {
      :location => user_panel_payment_requests_path
    }
  end

  private

  def fetch_payment_requests
    @payment_requests = current_user.
      payment_requests.order_by(:request_month.desc)
  end

end
