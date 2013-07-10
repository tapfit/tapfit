require 'crawler_validation/mailer_utils.rb'

class ResqueJob

  def self.queue; :crawler; end

  class LatLon
    attr_accessor :lat, :lon

    def initialize(lat, lon)
      @lat = lat
      @lon = lon
    end
  end

  def on_failure(e, *args)
    message = "Resque job failed: [#{self.to_s}, #{args.join(', ')}] : #{e.to_s}"
    MailerUtils.write_error(message)
  end
end

