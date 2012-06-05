require 'redis_model'

class Authorization < RedisModel

  ACTION = "http://mozcapag.com:2505/api/messaging/sendPinMt/"
  KEY = "STUB" # TODO
  MESSAGE = "STUB" # TODO

  def self.create(file, address)
    super
    self.url = file.generate_url address
  end

  def activate params
    self.phone = params[:msisdn]
    self.timestamp = Time.parse("#{params[:data]} #{params[:time]}").to_i
    self.carrier = carrier_name(params[:carrier_id])
    self.pin = params[:pin]
    self.price = params[:pricepoint]
    self.type = params[:type]
    self.valid = true
  end

  def confirm
    Curl::Easy.perform(url)
  end

  private

  def url
    args = {
      :key => KEY,
      :pin => self.pin,
      :text => MESSAGE,
      :phone => self.phone,
      :carrier_id => self.carrier_id
    }
    "#{ACTION}?#{args.to_query}"
  end

end
