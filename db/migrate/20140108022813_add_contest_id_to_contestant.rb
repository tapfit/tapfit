class AddContestIdToContestant < ActiveRecord::Migration
  def change
    add_reference :contestants, :contest, index: true
  end
end
