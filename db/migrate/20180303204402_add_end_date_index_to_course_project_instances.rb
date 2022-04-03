# frozen_string_literal: true

class AddEndDateIndexToCourseProjectInstances < ActiveRecord::Migration[5.1]
  def change
    add_index :course_project_instances, :end_date
  end
end
