class AddAssignedProjectIdToProjectDeliveries < ActiveRecord::Migration[5.1]
  def change
    add_reference :project_deliveries, :assigned_project, null: false
  end
end
