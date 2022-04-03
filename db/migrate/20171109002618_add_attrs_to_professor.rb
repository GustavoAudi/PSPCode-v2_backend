# frozen_string_literal: true

class AddAttrsToProfessor < ActiveRecord::Migration[5.1]
  def change
    add_column :professors, :first_name, :string
    add_column :professors, :last_name, :string
    add_column :professors, :additional_notes, :string
  end
end
