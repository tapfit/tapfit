require './lib/twitter/authentication'
require './lib/twitter/get_followers'

module Favorite

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

  def self.oauth_token
    return @oauth_token
  end

  def self.oauth_token_secret
    return @oauth_token_secret
  end

end
