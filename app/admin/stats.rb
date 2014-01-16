require './lib/admin/stats'

ActiveAdmin.register_page "Stats" do

  content do
    render 'index'
  end

  controller do
    def index
      stop_date = DateTime.parse('2013-09-02')

      date = DateTime.now.beginning_of_week + 1.weeks
      @stats = []
      while date > stop_date
        @stats << Stats.new(date)
        date = date - 1.weeks
      end

      @stats.each do |stat|
        puts stat.wow_purchase_amount
      end
    end
  end
end
