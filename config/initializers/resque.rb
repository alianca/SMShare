require 'resque/job_with_status'

  Resque.redis = "localhost:6379"
  Resque::Status.expire_in = (24 * 60 * 60) # 24hrs in seconds
