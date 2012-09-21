require 'redis_model'
require 'base64'
require 'digest/md5'

class Authorization < RedisModel
  SECRET = 'WJlY2E4ZjgwYmFiYzk0YWI4YmRhMjcgIC0K'

  ACTION = "http://mozcapag.com:2505/api/messaging/sendPinMt/"
  KEY    = "9698CF3F4B2F2598B5AB5181C"
  OI     = "4" # CarrierID da OI

  def self.register params
    raise Exception.new(:invalid_pin) if params[:pin].blank?
    self.new params[:pin], {
      :msisdn     => params[:msisdn],
      :value      => params[:value],
      :carrier_id => params[:carrier_id],
      :count      => params[:carrier_id] == OI ? 6 : 1
    }
  end

  def self.url_for(id, file, address)
    auth = self.find(id)
    raise Exception.new("not_key") if auth.nil?
    if Curl::Easy.perform(auth.confirm_url).body_str != "0"
      raise Exception.new("invalid_key")
    end
    auth.count--
    auth.destroy unless auth.count > 0

    expire = (Time.now + 5.hours).to_i
    path = file.filepath.split('/').last
    md5 = Digest::MD5.digest(
      "#{address}:#{SECRET}:#{path}:#{expire}"
    )
    hash = Base64.encode64(md5).tr('+/', '-_').gsub(/[=\n]/, '')

    "HTTP://#{$file_server}/files/#{hash}/#{expire}/#{path}/"+
      "#{file.filename}"
  end
  
  def message
    "SMSHARE: Compra feita a R$#{"%0.2f"%self.value}+tributos!"+
      " Digite #{self.id} no site para baixar #{self.count}"+
      " conteúdo#{self.count>1 ? "s" : ""}."+
      " Conteúdo extra wap.smshare.com.br acesso tarifado."
  end

  def confirm_url
    args = {
      :key        => KEY,
      :pin        => self.id,
      :text       => self.message,
      :phone      => self.msisdn,
      :carrier_id => self.carrier_id
    }
    "#{ACTION}?#{args.to_query}"
  end

end
