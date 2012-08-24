Factory.define :payment_request do |pr|
  pr.user { |pr| pr.association :user }
  pr.payment_method :paypal
  pr.payment_account { |pr| pr.user.email } 
  pr.value 10.0
  pr.referred_value 15.50
end
