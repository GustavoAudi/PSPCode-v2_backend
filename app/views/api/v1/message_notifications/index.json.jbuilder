json.message_notifications do
  json.array! @message_notifications do |message_notification|
    json.partial! 'api/v1/message_notifications/info', message_notification:
  end
end
json.not_seen_notfications @message_notifications.where('created_at > ?',
                                                        current_authenticated.last_seen_message_notification).count
