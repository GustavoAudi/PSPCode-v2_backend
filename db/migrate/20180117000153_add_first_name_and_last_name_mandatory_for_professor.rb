# frozen_string_literal: true

class AddFirstNameAndLastNameMandatoryForProfessor < ActiveRecord::Migration[5.1]
  def change
    change_column_null :professors, :first_name, true
    change_column_null :professors, :last_name, true
  end
end
