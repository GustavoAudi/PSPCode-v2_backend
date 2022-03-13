class AddFirstLastAttrsToPhaseInstance < ActiveRecord::Migration[5.1]
  def change
    add_column :phase_instances, :first, :boolean, default: false
    add_column :phase_instances, :last, :boolean, default: false
  end
end
