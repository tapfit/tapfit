require 'crawler_validation/mailer_utils.rb'
Dir["./lib/crawler_validation/*.rb"].each { |file| require file }

class ResqueJob

  def self.queue; :crawler; end

  def on_failure(e, *args)
    message = "Resque job failed: [#{self.to_s}, #{args.join(', ')}] : #{e.to_s}"
    MailerUtils.write_error(message)
  end
end

