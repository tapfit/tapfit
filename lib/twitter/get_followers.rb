require './lib/twitter/favorite'

module GetFollowers

  @followers = []

  def self.get_followers
    
    access_token = Authentication.prepare_access_token(Favorite.oauth_token, Favorite.oauth_token_secret)
    
    response = access_token.request(:get, "https://api.twitter.com/1.1/followers/ids.json")

    json = JSON.parse(response.body.to_str)
    
    @followers = json["ids"]

  end

  def self.followers
    return @followers
  end

end
