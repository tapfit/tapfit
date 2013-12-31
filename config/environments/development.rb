Tapfit::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.action_mailer.default_url_options = { :host => 'localhost:3000' }
 
  ENV["MIXPANEL_TOKEN"] = "8da0869d7ee062dfed009dc9fb6d2b27"

  ENV["OPENREDIS_URL"] = "redis://127.0.0.1:6379/0"

  ENV["BRAINTREE_ENV"] = "test"
  ENV["BRAINTREE_MERCHANT_ID"] = "8jw86r7bmx93rxfn"
  ENV["BRAINTREE_PUBLIC_KEY"] = "vxv67ybrg26z8796"
  ENV["BRAINTREE_PRIVATE_KEY"] = "418e1f6c1ffdd1cd2cfd95e3d087271e"
  #ENV["REDISTOGO_URL"] = 'redis://redistogo:f94459718df1ee5942b0ab27f3cc753c@grouper.redistogo.com:9503/'
  
  ENV["MANDRILL_APIKEY"] = 'XdYDGPC2pLDIrcWUXiH7hg'

  ENV["ANALYTICS_ENV"] = "test"

  ENV["SEND_TEXTS"] = 'false' 

  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => 'tapfit-staging',
      :access_key_id => 'AKIAIII6AM3XT6ZJCPAA',
      :secret_access_key => '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'
    }
  }

  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.gmail.com",
    :port                 => 587,
    :domain               => "gmail.com",
    :user_name            => "zackmartinsek@gmail.com",
    :password             => "medo1234",
    :authentication       => "plain",
    :enable_starttls_auto => true
  }
end
