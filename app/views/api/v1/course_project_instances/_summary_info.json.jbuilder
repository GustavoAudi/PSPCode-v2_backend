# frozen_string_literal: true

json.id course_project_instance.id
json.name course_project_instance.name
json.deadline course_project_instance.end_date
json.partial! 'api/v1/project/info', project: course_project_instance.project
