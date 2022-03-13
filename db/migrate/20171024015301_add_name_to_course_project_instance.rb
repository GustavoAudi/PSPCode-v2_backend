class AddNameToCourseProjectInstance < ActiveRecord::Migration[5.1]
  def change
    add_column :course_project_instances, :name, :string
  end
end
