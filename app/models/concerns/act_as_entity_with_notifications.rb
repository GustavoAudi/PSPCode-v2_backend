module ActAsEntityWithNotifications
  extend ActiveSupport::Concern

  included do
    validates :last_seen_event_notification,
              :last_seen_message_notification, presence: true

    before_validation :set_last_seen_values, on: :create
  end

  def set_last_seen_values
    current_time = DateTime.now
    self.last_seen_event_notification = current_time
    self.last_seen_message_notification = current_time
  end
end
