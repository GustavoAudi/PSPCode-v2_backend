# frozen_string_literal: true

class CreateAssignedProjects < ActiveRecord::Migration[5.1]
  def change
    create_table :assigned_projects do |t|
      t.references :course_project_instance, null: false
      t.references :user, null: false
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
