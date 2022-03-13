json.id message_notification.id
json.created_at message_notification.created_at
json.assigned_project do
  json.partial! 'api/v1/assigned_projects/info',
                 assigned_project: message_notification.assigned_project
  json.user do
    json.partial! 'api/v1/users/info', user: message_notification.assigned_project.user
  end
end

json.originator do
  if message_notification.originator.is_a?(User)
  json.partial! 'api/v1/users/info', user: message_notification.originator
  else
  json.partial! 'api/v1/professors/info', professor: message_notification.originator
  end
end
