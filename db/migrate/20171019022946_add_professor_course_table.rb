class AddProfessorCourseTable < ActiveRecord::Migration[5.1]
  def change
    create_table :professor_courses do |t|
      t.references :professor, null: false
      t.references :course, null: false
      t.timestamps
    end
  end
end
