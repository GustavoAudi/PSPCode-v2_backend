# frozen_string_literal: true

json.key project.id
json.name project.course_project_instance.name
json.assigned project.created_at
json.deadline project.course_project_instance.end_date
json.status project.status
json.version_number project.version_number
json.process do
  json.partial! 'api/v1/psp_processes/info', process: project.process
end
