require 'digest/md5'

class RedisModel

  def self.create
    self.new Digest::MD5.hexdigest($redis.incr("#{self.class.name}:count"))
  end

  def self.method_missing(method_sym, **kvargs)
    case method_sym.to_s
    when /(\w*)=/
      $redis.hset(key, $1, kvargs[0])
    when /(\w*)?/
      $redis.hexists(key, $1)
    when /(\w*)/
      if self.send "#{$1}?"
        $redis.hget(key, method_sym)
      else
        raise NoMethodError.new method_sym.to_s
      end
    else
      raise NoMethodError.new method_sym.to_s
    end
  end

  def id
    @id
  end

  def self.find(id)
    if $redis.exists("#{self.name}:#{id}")
      model = self.new id
    else
      nil
    end
  end

  private

  def initialize id
    @id = id
  end

  def key
    "#{self.class.name}:#{id}"
  end

end
