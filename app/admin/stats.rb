require './lib/admin/stats'

ActiveAdmin.register_page "Stats" do

  content do
    render 'index'
  end

  controller do
    def index
      @stats = Stats.new
    end
  end
end
