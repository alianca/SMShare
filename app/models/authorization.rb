require 'redis_model'
require 'base64'
require 'digest/md5'

class Authorization < RedisModel
  SECRET = 'WJlY2E4ZjgwYmFiYzk0YWI4YmRhMjcgIC0K'

  ACTION = "http://mozcapag.com:2505/api/messaging/sendPinMt/"
  KEY    = "9698VE1EF4C2DF4003FF4940F"
  OI     = "4" # CarrierID da OI

  def self.register params
    params.each { |k, v|
      Rails.logger.info "PARAM[#{k}] => #{v}"
    }
    return "0" if params[:pin].blank?
    auth = self.new params[:pin], {
      :msisdn     => params[:msisdn],
      :value      => params[:value],
      :carrier_id => params[:carrier_id],
      :count      => (params[:value].to_f / 0.31).floor.to_i
    }
    auth.check
  end

  def self.url_for(id, file, address)
    auth = self.find(id)
    return nil if auth.nil?
    
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

  def check
    url = confirm_url
    Rails.logger.info "Sending MT: #{url}"
    if Curl::Easy.perform(confirm_url).body_str != "0"
      self.destroy
      return "0"
    end
    return "1"
  end
  
  def message
    "SMSHARE: Compra feita a R$#{self.value}+tributos!"+
      " Digite #{self.id} no site para baixar #{self.count}"+
      " conteúdo#{self.count.to_i > 1 ? "s" : ""}."+
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
