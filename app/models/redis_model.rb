class RedisModel
  attr_accessor :id

  def update(attributes)
    $redis.hmset(key, attributes.to_a.flatten)
  end

  def initialize(id, attributes = nil)
    self.id = id
    update(attributes) unless attributes.nil?
  end

  def method_missing(method_sym, *args, &block)
    case method_sym.to_s
    when /^(\w+)=$/
      set($1, args[0])
    when /^(\w+)\?$/
      has($1)
    when /^(\w+)$/
      get($1)
    else
      raise NoMethodError.new method_sym.to_s
    end
  end

  def get(field)
    $redis.hget(key, field)
  end

  def set(field, value)
    $redis.hset(key, field, value)
  end

  def has(field)
    $redis.hexists(key, field)
  end

  def key
    "#{self.class.name}:#{self.id}"
  end

  def destroy
    $redis.del(key)
  end


  # Class methods

  def self.find(id)
    if $redis.exists("#{self.name}:#{id}")
      self.new id
    else
      nil
    end
  end

end
