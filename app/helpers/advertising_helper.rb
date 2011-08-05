module AdvertisingHelper
  
  def reference_url(ref)
    "http://www.smshare.com.br/?ref=" + current_user.nickname + "&ban=" + ref.name
  end
  
end
