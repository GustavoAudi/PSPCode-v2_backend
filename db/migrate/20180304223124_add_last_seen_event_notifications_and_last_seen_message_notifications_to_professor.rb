class AddLastSeenEventNotificationsAndLastSeenMessageNotificationsToProfessor < ActiveRecord::Migration[5.1]
  def change
    add_column :professors, :last_seen_event_notification, :datetime
    add_column :professors, :last_seen_message_notification, :datetime
  end
end
