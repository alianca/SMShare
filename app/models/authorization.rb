class Authorization

  BOUND = 6.hours

  def self.create(id, address)
    $redis.hset("authorizations", key(id, address), Time.now)
  end

  def self.is_valid?(id, address)
    key = key(id, address)
    if $redis.hexists("authorizations", key)
      $redis.hset("authorizations", key, Time.now)
      true
    else
      false
    end
  end

  def self.cleanup!
    $redis.hkeys("authorizations").each do |key|
      last_access = $redis.hget("authorizations", key)
      if Time.now - last_access > BOUND
        $redis.hdel("authorizations", key)
      end
    end
  end

  private

  def self.key(id, address)
    "#{id}-#{address}"
  end

end
