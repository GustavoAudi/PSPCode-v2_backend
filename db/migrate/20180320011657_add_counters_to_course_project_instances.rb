# frozen_string_literal: true

class AddCountersToCourseProjectInstances < ActiveRecord::Migration[5.1]
  def change
    add_column :course_project_instances, :assigned_count, :integer, default: 0
    add_column :course_project_instances, :working_count, :integer, default: 0
    add_column :course_project_instances, :being_corrected_count, :integer, default: 0
    add_column :course_project_instances, :approved_count, :integer, default: 0
    add_column :course_project_instances, :need_correction_count, :integer, default: 0
  end
end
