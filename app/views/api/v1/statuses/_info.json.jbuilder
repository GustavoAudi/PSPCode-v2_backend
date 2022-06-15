# frozen_string_literal: true

json.id status.id
json.status status.value
json.date status.created_at
json.version do
  json.id status.project_delivery_id
  json.version status.project_delivery.version_number
end
