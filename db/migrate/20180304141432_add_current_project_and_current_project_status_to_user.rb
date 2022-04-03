# frozen_string_literal: true

class AddCurrentProjectAndCurrentProjectStatusToUser < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :current_assigned_project
  end
end
