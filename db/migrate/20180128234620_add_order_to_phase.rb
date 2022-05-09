class AddOrderToPhase < ActiveRecord::Migration[5.1]
  def change
    # TODO, check if it's worth to add a null: false property
    add_column :phases, :order, :integer
    add_column :phases, :first, :boolean, default: false
    add_column :phases, :last, :boolean, default: false
  end
end
