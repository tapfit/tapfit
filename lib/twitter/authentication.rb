module Authentication

  def self.prepare_access_token(oauth_token, oauth_token_secret)
    
    consumer = OAuth::Consumer.new("Y1dtYVVReDb3DPBVnDI5Ww", 
                                   "F6Uh22XuzEwfw5BBadjgyxo4wQfr8jHDgRf19iUP28",
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
