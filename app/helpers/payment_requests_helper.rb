module PaymentRequestsHelper
  def total_payments_received unit_class = "stat_unit"
    number_to_currency(current_user.statistics.payments_received + current_user.statistics.referred_payments_received || 0, :format => "<span class=\"#{unit_class}\">R$</span>%n")
  end
  
  def total_revenue_available_for_payment unit_class = "stat_unit"
    number_to_currency(current_user.statistics.revenue_available_for_payment + current_user.statistics.referred_revenue_available_for_payment || 0, :format => "<span class=\"#{unit_class}\">R$</span>%n")
  end
  
  def payment_request_for_this_month
    return @payment_request_for_this_month unless @payment_request_for_this_month.nil?
    
    if Date.today.day > 5
        request_month = Date.new(Date.today.year, Date.today.month, 1)
    else
      if Date.today.month == 1
        request_month = Date.new(Date.today.year-1, 12, 1)
      else
        request_month = Date.new(Date.today.year, Date.today.month-1, 1)
      end
    end
    
    @payment_request_for_this_month = current_user.payment_requests.where(:request_month => request_month).first || current_user.payment_requests.new
  end  
end
