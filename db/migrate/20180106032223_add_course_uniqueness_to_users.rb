# frozen_string_literal: true

class AddCourseUniquenessToUsers < ActiveRecord::Migration[5.1]
  def change
    change_column :users, :course_id, :integer, null: false
  end
end
