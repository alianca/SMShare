module FeedsHelper
  def pub_date date
    date.strftime '%a, %d %b %Y %H:%M:%S %Z'
  end
end
