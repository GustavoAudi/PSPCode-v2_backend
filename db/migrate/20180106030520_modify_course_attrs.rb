# frozen_string_literal: true

class ModifyCourseAttrs < ActiveRecord::Migration[5.1]
  def change
    add_column :courses, :name, :string, null: false
    remove_column :courses, :edition_date
    remove_column :courses, :dictated_semester
  end
end
