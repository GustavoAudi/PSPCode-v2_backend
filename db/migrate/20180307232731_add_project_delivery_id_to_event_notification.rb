class AddProjectDeliveryIdToEventNotification < ActiveRecord::Migration[5.1]
  def change
    add_reference :event_notifications, :project_delivery
  end
end
