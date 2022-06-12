# frozen_string_literal: true

phase_instance = @assigned_project&.current_project_delivery&.phase_instances&.last
json.id @assigned_project&.id
json.name @assigned_project&.course_project_instance&.name
json.project_delivery_id @assigned_project&.current_project_delivery&.id
json.phase_instance do
  json.partial! 'api/v1/phase_instances/info', phase_instance: phase_instance if phase_instance.present?
end
