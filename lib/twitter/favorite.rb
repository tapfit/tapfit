require './lib/twitter/authentication'
require './lib/twitter/get_followers'

module FavoriteTweet

  @oauth_token = "22325444-KmejZYvgilgLgCVdmjuq8tGdo9YQvy8AjY9K4BM"
  @oauth_token_secret = "eyAEOtmq4Wr2YeZ4DI1BLcGrjJExk2rohXx44vMvybs"

  def self.favorite_tweets

    access_token = Authentication.prepare_access_token(@oauth_token, @oauth_token_secret)

    if GetFollowers.followers.length == 0
      GetFollowers.get_followers
    end

    search_params = [ "sql", "android", "startup", "yoga", "fitness" ]
    search_params.each do |search|

      response = access_token.request(:get, "https://api.twitter.com/1.1/search/tweets.json?q=#{search}")

      json = JSON.parse(response.body.to_str)
        
      json["statuses"].each do |status|
        
        if !GetFollowers.followers.include?(status["user"]["id"].to_i)
          response = access_token.request(:post, "https://api.twitter.com/1.1/favorites/create.json?id=#{status["id_str"]}")
          puts "Favorited tweet: #{status["text"]}"
        end
      end

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
