class AddPhaseTimeSummaryTable < ActiveRecord::Migration[5.1]
  def change
    create_table :phase_time_summaries do |t|
      t.integer :actual, default: 0
      t.references :phase, null: false
      t.references :project_delivery, null: false
      t.integer :previous_phase_time
      t.integer :to_date
      t.integer :plan
      t.timestamps
    end
  end
end
