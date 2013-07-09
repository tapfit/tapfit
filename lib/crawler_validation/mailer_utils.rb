module MailerUtils

  def self.redis_key
    return "#{DateTime.now.beginning_of_day}_errors"
  end

  def self.write_error(key, value, source)
    message = "#{key} was not valid: #{value}, from source: #{source}"
    puts "adding message to #{redis_key} with message: #{message}"
    REDIS.lpush(redis_key, message)
  end

  def self.send_error_email
    body = ""
    if REDIS.exists(redis_key)
      while REDIS.llen(redis_key) > 0 do
        body = body + "\n#{REDIS.lpop(redis_key)}"
        puts body
      end
    else
      body = "No errors today"
    end

    puts "Sending email: #{body}"
  end
end
