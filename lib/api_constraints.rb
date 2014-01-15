class ApiConstraints
  def initialize(options)
    @version = options[:version]
    @default = options[:default]
  end

  def matches?(req)
    puts "Checking header: #{req.headers['Accept']}"
    puts @version
    @default || req.headers['Accept'].include?("application/vnd.example.v#{@version}")
  end
end
