class AddProjectFeedbackTable < ActiveRecord::Migration[6.1]
  def change
    create_table :project_feedbacks do |t|
      t.string :comment
      t.boolean :approved, default: false
      t.date :delivered_date, null: false
      t.date :reviewed_date
      t.references :project_delivery, null: false
    end
  end
end