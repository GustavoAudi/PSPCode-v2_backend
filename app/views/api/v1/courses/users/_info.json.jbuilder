# frozen_string_literal: true

json.id                   user.id
json.first_name           user.first_name
json.last_name            user.last_name
json.email                user.email
json.member_since         user.created_at
json.role                 'student'
json.programming_language user.programming_language
json.professor do
  json.partial! 'api/v1/professors/info',
                professor: user.professor
end

json.current_project do
  json.id user.current_assigned_project&.course_project_instance&.id
  json.name user.current_assigned_project&.course_project_instance&.name
  json.status user.current_assigned_project&.status
  json.deadline user.current_assigned_project&.course_project_instance&.end_date
  json.assigned_project_id user.current_assigned_project&.id
end
