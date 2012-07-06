require 'redis_model'
require 'base64'
require 'digest/md5'

class Authorization < RedisModel

  SECRET = 'it_is_people'

  ACTION = "http://mozcapag.com:2505/api/messaging/sendPinMt/"
  KEY = "9698CF3F4B2F2598B5AB5181C"
  MESSAGE = "Thy download shall start soon." # TODO

  def self.register params
    raise 'Invalid pin' if params[:pin].blank?
    self.new params[:pin], {
      :msisdn => params[:msisdn],
      :carrier_id => params[:carrier_id]
    }
  end

  def url_for(file, address)
    raise 'Invalid key' if Curl::Easy.perform(confirm_url).body_str != "0"
    expire = (Time.now + 5.hours).to_i
    path = file.filepath.split('/').last
    md5 = Digest::MD5.digest("#{address}:#{SECRET}:#{path}:#{expire}")
    hash = Base64.encode64(md5).tr('+/', '-_').gsub(/[=\n]/, '')
    "/files/#{hash}/#{expire}/#{path}/#{file.filename}"
  end

  private

  def confirm_url
    args = {
      :key => KEY,
      :pin => self.id,
      :text => MESSAGE,
      :phone => self.msisdn,
      :carrier_id => self.carrier_id
    }
    "#{ACTION}?#{args.to_query}"
  end

end
