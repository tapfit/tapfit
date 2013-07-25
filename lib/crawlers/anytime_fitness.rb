require 'nokogiri'
require 'open-uri'
require './lib/resque_job'

class AnytimeFitness < ResqueJob

  attr_accessor :base_url

  @source = "anytimefitness"
  @base_url = "http://www.anytimefitness.com/find-gym/list/"

  def self.perform(url, arg, arg1)
    if url == 1
      @states.each do |state|
        Resque.enqueue(AnytimeFitness, state, true, true)
      end
    else
      AnytimeFitness.get_location("#{@base_url}#{url}")
    end
  end

  def self.get_location(url)
    doc = Nokogiri::HTML(open(url))

    doc.xpath("//tr[starts-with(@style, 'border-bottom:')]").each do |gym|
      puts gym.children.count
      if gym.children[0].content == "open"
        
        name = "Anytime Fitness - #{gym.children[2].content}"
        
        if ProcessLocation.get_place_id(@source, "#{@source}/#{name}").nil?

          address = {}
          split = gym.children[4].content.split("   ")
          address[:line1] = split[0].strip
          city_state = split[split.length - 1].strip.split(",")
          address[:city] = city_state[0]
          state_zip = city_state[1].split(" ")
          address[:zip] = state_zip.delete_at(state_zip.length - 1)
          address[:state] = state_zip.join(" ")

          opts = {}

          opts[:name] = name
          opts[:address] = address
          opts[:url] = "http://www.anytimefitness.com#{gym.children[8].children[0]['href']}"
          opts[:phone_number] = gym.children[6].content
          opts[:source] = @source
          opts[:category] = Category::Gym
          opts[:tags] = [Category::Gym, Category::Strength, Category::Cardio]

          process_location = ProcessLocation.new(opts)
          process_location.save_to_database(@source)

        end
      end

    end
  end



private

  @states = ["AL", "AK", "AR", "AZ", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY" ]


end
