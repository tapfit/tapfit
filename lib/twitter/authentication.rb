module Authentication

  def self.prepare_access_token(oauth_token, oauth_token_secret)
    
    consumer = OAuth::Consumer.new("zfn17AnzuDG6puceIaP5oA", 
                                   "Hm3SvTQx4wEqockhBNeK7DrsMmQFjmdz2LwNHz8PA4",
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
