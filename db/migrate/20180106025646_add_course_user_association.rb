# frozen_string_literal: true

class AddCourseUserAssociation < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :course
  end
end
