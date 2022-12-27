class AddCorrectionTable < ActiveRecord::Migration[6.1]
  def change
    create_table :corrections do |t|
      t.boolean :approved, default: false
      t.string :comment
      t.references :criterion, null: false
      t.references :project_feedback, null: false
    end
  end
end