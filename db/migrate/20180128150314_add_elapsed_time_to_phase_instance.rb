class AddElapsedTimeToPhaseInstance < ActiveRecord::Migration[5.1]
  def change
    add_column :phase_instances, :elapsed_time, :integer, default: 0, index: true
  end
end
