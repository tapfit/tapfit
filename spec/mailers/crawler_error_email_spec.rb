require 'spec_helper'

describe CrawlerErrorEmail do
  
  before(:each) do
    @message = "Test message"
  end 

  it 'sends an email to me' do
    CrawlerErrorEmail.error_email(@message) 
    (!ActionMailer::Base.deliveries.empty?).should be_true
  end
end
