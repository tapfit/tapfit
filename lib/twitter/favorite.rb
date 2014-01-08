require './lib/twitter/authentication'
require './lib/twitter/get_followers'

module FavoriteTweet

  @oauth_token = "1545914628-CoaxLwU0tts4dX6d0BIpeSGIZ3jhYyzejTDc5Y1"
  @oauth_token_secret = "3AmObnDiYwPIAht25Y6FOn9AWCUuPdouBrq4ANeY"

  def self.favorite_tweets

    access_token = Authentication.prepare_access_token(@oauth_token, @oauth_token_secret)

    if GetFollowers.followers.length == 0
      GetFollowers.get_followers
    end

    search_params = [ "bikram", "workout", "gym", "yoga", "fitness" ]
    geocode = "41.882287,-87.627462,50mi"
    search_params.each do |search|
      
      response = ""
      since_id = REDIS.get("since_id_#{search}")
      if since_id == nil
        puts "since_id does not exist"
        response = access_token.request(:get, "https://api.twitter.com/1.1/search/tweets.json?q=#{search}&geocode=#{geocode}")
      else
        puts "since_id = #{since_id}"
        response = access_token.request(:get, "https://api.twitter.com/1.1/search/tweets.json?q=#{search}&geocode=#{geocode}&since_id=#{since_id}")
      end
      
      puts response.body.to_str
      json = JSON.parse(response.body.to_str)
        
      json["statuses"].each do |status|
        
        if !GetFollowers.followers.include?(status["user"]["id"].to_i)
          response = access_token.request(:post, "https://api.twitter.com/1.1/favorites/create.json?id=#{status["id_str"]}")
          REDIS.set("since_id_#{search}", status["id_str"])
          puts "Favorited tweet: #{status["text"]}"
        end
      end
      
      puts "since_id is now = #{REDIS.get("since_id_#{search}")}"
    end

    return nil
  end

  def self.clear_favorites
     
    access_token = Authentication.prepare_access_token(@oauth_token, @oauth_token_secret)

    num = 25

    while num > 10 do

      response = access_token.request(:get, "https://api.twitter.com/1.1/favorites/list.json")

      json = JSON.parse(response.body.to_str)

      num =  json.length
          
      json.each do |status|
        # puts "ID: #{status}" 

        if !status["id"].nil? 
          response = access_token.request(:post, "https://api.twitter.com/1.1/favorites/destroy.json?id=#{status["id"]}")
          
          puts "Deleted tweet: #{status["id"]}"
        end
      end
      
      # return
    end

    return nil

  end

  def self.oauth_token
    return @oauth_token
  end

  def self.oauth_token_secret
    return @oauth_token_secret
  end

end
