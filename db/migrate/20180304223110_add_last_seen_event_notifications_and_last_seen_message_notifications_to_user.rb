class AddLastSeenEventNotificationsAndLastSeenMessageNotificationsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :last_seen_event_notification, :datetime
    add_column :users, :last_seen_message_notification, :datetime
  end
end
