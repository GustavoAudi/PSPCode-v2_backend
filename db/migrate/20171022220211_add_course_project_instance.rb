class AddCourseProjectInstance < ActiveRecord::Migration[5.1]
  def change
    create_table :course_project_instances do |t|
      t.references :project, null: false
      t.references :course, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.timestamps
    end
  end
end
