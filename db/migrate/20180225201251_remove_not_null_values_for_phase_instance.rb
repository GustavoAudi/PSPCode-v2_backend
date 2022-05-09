class RemoveNotNullValuesForPhaseInstance < ActiveRecord::Migration[5.1]
  def change
    change_column :phase_instances, :start_time, :datetime, null: true
    change_column :phase_instances, :end_time, :datetime, null: true
    change_column :phase_instances, :phase_id, :integer, null: true
    change_column :phase_instances, :plan_time, :integer, default: 0
    change_column :phase_instances, :plan_loc, :integer, default: 0
    change_column :phase_instances, :actual_base_loc, :integer, default: 0
    change_column :phase_instances, :modified, :integer, default: 0
    change_column :phase_instances, :deleted, :integer, default: 0
    change_column :phase_instances, :reused, :integer, default: 0
    change_column :phase_instances, :new_reusable, :integer, default: 0
    change_column :phase_instances, :total, :integer, default: 0
    change_column :phase_instances, :pip_problem, :string, default: ''
    change_column :phase_instances, :pip_proposal, :string, default: ''
    change_column :phase_instances, :pip_notes, :string, default: ''
  end
end
