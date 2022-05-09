class AddAssignedProjectCountToCourseProjectInstance < ActiveRecord::Migration[5.1]
  def change
    add_column :course_project_instances, :assigned_projects_count, :integer, default: 0
  end
end
