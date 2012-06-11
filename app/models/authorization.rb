require 'redis_model'

class Authorization < RedisModel

  ACTION = "http://mozcapag.com:2505/api/messaging/sendPinMt/"
  KEY = "STUB" # TODO
  MESSAGE = "STUB" # TODO

  def activate params
    url = confirm_url(params[:pin], params[:msisdn], params[:carrier_id])
    Curl::Easy.perform(url) do |response|
      if response.body_str == "0"
        begin
          @file = UserFile.find(BSON::ObjectId(self.file_id))
          self.url = @file.generate_url(self.address)
        rescue
          self.url = "/404.html"
        end
      else
        self.url = "/404.html"
      end
    end
  end

  private

  def confirm_url(pin, phone, carrier)
    args = {
      :key => KEY,
      :pin => pin,
      :text => MESSAGE,
      :phone => phone,
      :carrier_id => carrier
    }
    "#{ACTION}?#{args.to_query}"
  end

end
