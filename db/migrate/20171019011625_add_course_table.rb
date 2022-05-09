class AddCourseTable < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.date :edition_date, null: false
      t.integer :dictated_semester, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :description
      t.string :additional_notes
      t.timestamps
    end
  end
end
