require 'redis_model'
require 'base64'
require 'digest/md5'

class Authorization < RedisModel

  SECRET = 'it_is_people'

  ACTION = "http://localhost/verify_test" #"http://mozcapag.com:2505/api/messaging/sendPinMt/"
  KEY = "STUB" # TODO
  MESSAGE = "STUB" # TODO

  def self.register params
    self.new params[:pin], {
      :msisdn => params[:msisdn],
      :carrier_id => params[:carrier_id]
    }
  end

  def url_for(file, address)
    if Curl::Easy.perform(confirm_url).body_str == "0"
      expire = (Time.now + 5.hours).to_i
      path = file.filepath.split('/').last
      hash = Base64.encode64(Digest::MD5.digest("#{address}:#{SECRET}:#{path}:#{expire}")).tr('+/', '-_').gsub(/[=\n]/, '')
      "/files/#{hash}/#{expire}/#{path}/#{file.filename}"
    else
      nil
    end
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
