# frozen_string_literal: true

class AddProjectDeliveryIdToStatuses < ActiveRecord::Migration[5.1]
  def change
    add_reference :statuses, :project_delivery
  end
end
