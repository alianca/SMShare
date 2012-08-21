Factory.define :payment_request do |pr|
  pr.payment_method :paypal
  pr.payment_account 'test_account@test.com'
  pr.value 10.0
  pr.referred_value 15.50
end
