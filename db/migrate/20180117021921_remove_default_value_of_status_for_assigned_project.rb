# frozen_string_literal: true

class RemoveDefaultValueOfStatusForAssignedProject < ActiveRecord::Migration[5.1]
  def change
    change_column_default :assigned_projects, :status, nil
  end
end
