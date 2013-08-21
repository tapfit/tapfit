require './lib/twitter/favorite'
require './lib/twitter/authentication'

module Follow

  def self.unfollow

    access_token = Authentication.prepare_access_token(FavoriteTweet.oauth_token, FavoriteTweet.oauth_token_secret)

    if GetFollowers.followers.length == 0
      GetFollowers.get_followers
    end

    response = access_token.request(:get, "https://api.twitter.com/1.1/friends/ids.json")

    json = JSON.parse(response.body.to_str)
    
    num = 0

    json["ids"].each do |id|
      if num < 100
        if !GetFollowers.followers.include?(id)
          response = access_token.request(:post, "https://api.twitter.com/1.1/friendships/destroy.json?user_id=#{id}")
          puts "Unfollowed user: #{id}"
          num = num + 1
        end
      else
        return
      end
    end

  end

  def self.follow
    
    access_token = Authentication.prepare_access_token(FavoriteTweet.oauth_token, FavoriteTweet.oauth_token_secret)

    if GetFollowers.followers.length == 0
      GetFollowers.get_followers
    end

    search = "500Startups"


    have_followed = REDIS.lrange("follow", 0, REDIS.llen("follow")).map { |int| int.to_i }

    response = access_token.request(:get, "https://api.twitter.com/1.1/followers/ids.json?user_id=168857946")

    json = JSON.parse(response.body.to_str)
    
    num = 0

    json["ids"].each do |id|
      if num < 10
        response = access_token.request(:get, "https://api.twitter.com/1.1/users/show.json?user_id=#{id}")
        user = JSON.parse(response.body.to_str)
        if user["following"] == false && user["follow_request_sent"] == false && !have_followed.include?(id)
          access_token.request(:post, "https://api.twitter.com/1.1/friendships/create.json?user_id=#{id}")
          puts "following user: #{id}"
          REDIS.lpush("follow", id)
          num = num + 1
        end
      else
        return
      end
    end

  end   

end

