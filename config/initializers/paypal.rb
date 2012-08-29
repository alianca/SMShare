if Rails.env == :production
  $paypal_user = "TODO_use_real_user"
  $paypal_pass = "TODO_use_real_pass"
  $paypal_sign = "TODO_use_real_sign"
  $paypal_url  = "https://api-3t.paypal.com/nvp/2.0"
else
  $paypal_user = "edric_1346261539_biz_api1.gmail.com"
  $paypal_pass = "1346261562"
  $paypal_sign = "A5qZcrIo.lWZbMib2vThHrp07k-IA8r9moHHt3NKp2QMDYloLQ6s45h."
  $paypal_url  = "https://api.sandbox.paypal.com/nvp"
end
