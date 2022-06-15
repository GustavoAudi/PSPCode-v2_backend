# frozen_string_literal: true

json.key assigned_project.id
json.name assigned_project.course_project_instance.name
json.assigned assigned_project.created_at
json.deadline assigned_project.course_project_instance.end_date
json.status assigned_project.status
json.process do
  json.partial! 'api/v1/psp_processes/info', process: assigned_project.process
end
