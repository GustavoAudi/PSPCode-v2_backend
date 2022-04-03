# frozen_string_literal: true

class AddProcesToCourseProjectInstance < ActiveRecord::Migration[5.1]
  def change
    add_column :course_project_instances, :process_name, :string, null: false
  end
end
