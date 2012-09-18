require 'redis_model'
require 'base64'
require 'digest/md5'

class Authorization < RedisModel
  SECRET = 'WJlY2E4ZjgwYmFiYzk0YWI4YmRhMjcgIC0K'

  ACTION = "http://mozcapag.com:2505/api/messaging/sendPinMt/"
  KEY = "9698CF3F4B2F2598B5AB5181C"
  OI = 1 # TODO

  def self.register params
    raise :invalid_pin if params[:pin].blank?
    self.new params[:pin], {
      :msisdn => params[:msisdn],
      :carrier_id => params[:carrier_id],
      :count => (params[:carrier_id] == OI ? 6 : 1)
    }
  end

  def self.url_for(id, file, address)
    #auth = self.find(id)
    #raise :invalid_key if auth.nil?
    #raise :invalid_key if Curl::Easy.perform(auth.confirm_url).body_str != "0"

    expire = (Time.now + 5.hours).to_i
    path = file.filepath.split('/').last
    md5 = Digest::MD5.digest("#{address}:#{SECRET}:#{path}:#{expire}")
    hash = Base64.encode64(md5).tr('+/', '-_').gsub(/[=\n]/, '')

    #auth.count--
    #auth.destroy unless auth.count > 0

    "http://#{$file_server}/files/#{hash}/#{expire}/#{path}/#{file.filename}"
  end

private
  
  def message
    if self.carrier_id == OI
      "Digite XXXXXX no campo do site para baixar 6 conteúdos (RS 1,99+tributos). Acesso tarifado ao conteúdo extra: wap.smsha.re"
    else
      "Digite XXXXXX no campo do site para baixar seu conteúdo (RS 0,31+tributos). Acesso tarifado ao conteúdo extra: wap.smsha.re"
    end
  end

  def confirm_url
    args = {
      :key => KEY,
      :pin => self.id,
      :text => self.message,
      :phone => self.msisdn,
      :carrier_id => self.carrier_id
    }
    "#{ACTION}?#{args.to_query}"
  end

end
