Dir["./lib/crawlers/*.rb"].each {|file| require file }

module Crawler
  
  def self.start_crawler_process
    Dir.glob("./lib/crawlers/*.rb").each do |file|
      File.open(file).each_line do |line|
        if line.include?("class")
          Resque.enqueue(Kernel.const_get(line.split(" ")[1]), 1, true, DateTime.now)
          break
        end
      end
    end
  end

end
