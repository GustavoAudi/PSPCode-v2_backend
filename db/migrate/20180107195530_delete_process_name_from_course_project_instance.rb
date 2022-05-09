class DeleteProcessNameFromCourseProjectInstance < ActiveRecord::Migration[5.1]
  def change
    remove_column :course_project_instances, :process_name
  end
end
