class AddPhaseInstanceTable < ActiveRecord::Migration[5.1]
  def change
    create_table :phase_instances do |t|
      t.string :start_time, null: false
      t.string :end_time, null: false
      t.references :phase, null: false
      t.references :project_delivery, null: false
      t.integer :interruption_time, default: 0
      t.integer :plan_time
      t.integer :plan_loc
      t.integer :actual_base_loc
      t.integer :modified
      t.integer :deleted
      t.integer :reused
      t.integer :new_reusable
      t.integer :total
      t.integer :pip_problem
      t.integer :pip_proposal
      t.integer :pip_notes
      t.string :comments
      t.timestamps
    end
  end
end
