# frozen_string_literal: true

class AddProcessReferenceToAssignedProject < ActiveRecord::Migration[5.1]
  def change
    add_reference :assigned_projects, :process
  end
end
