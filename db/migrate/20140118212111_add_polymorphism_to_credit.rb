class AddPolymorphismToCredit < ActiveRecord::Migration
  def change
    add_reference :credits, :source, index: true, :polymorphic => true
  end
end
