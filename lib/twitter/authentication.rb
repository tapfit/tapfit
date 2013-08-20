module Authentication

  def self.prepare_access_token(oauth_token, oauth_token_secret)
    
    consumer = OAuth::Consumer.new("Uuhgk5ZIIsfIctxGGRPqKw", 
                                   "e9Knzq63ALP9Y3ZkzlKww3iR6Oef6f6QwM612Zo34w",
                                       { :site => "http://api.twitter.com",
                                               :scheme => :header
        })
    # now create the access token object from passed values
    token_hash = { 
      :oauth_token => oauth_token,
      :oauth_token_secret => oauth_token_secret
    }
    access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
    return access_token
  
  end

end
