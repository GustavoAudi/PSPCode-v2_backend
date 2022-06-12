# frozen_string_literal: true

json.id event_notification.id
json.status event_notification.status
json.created_at event_notification.created_at
json.assigned_project do
  json.partial! 'api/v1/assigned_projects/info',
                assigned_project: event_notification.assigned_project
  json.user do
    json.partial! 'api/v1/users/info', user: event_notification.assigned_project.user
  end
end

json.originator do
  if event_notification.originator.is_a?(User)
    json.partial! 'api/v1/users/info', user: event_notification.originator
  else
    json.partial! 'api/v1/professors/info', professor: event_notification.originator
  end
end
