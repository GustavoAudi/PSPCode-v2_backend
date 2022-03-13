json.event_notifications do
  json.array! @event_notifications do |event_notification|
    json.partial! 'api/v1/event_notifications/info', event_notification: event_notification
  end
end
json.not_seen_notfications @event_notifications.where('created_at > ?', current_authenticated.last_seen_event_notification).count
