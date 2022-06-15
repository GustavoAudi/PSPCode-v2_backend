# frozen_string_literal: true

json.id assigned_project.id
json.psp_project do
  json.partial! 'api/v1/course_project_instances/summary_info',
                course_project_instance: assigned_project.course_project_instance
end

user = assigned_project.user
json.language user.programming_language
json.professor do
  json.partial! 'api/v1/professors/info',
                professor: user.professor
end

json.course do
  json.partial! 'api/v1/courses/info', course: assigned_project.course_project_instance.course
end

json.course_project_instance do
  json.id               assigned_project.course_project_instance.id
  json.name             assigned_project.course_project_instance.name
  json.start_date       assigned_project.course_project_instance.start_date
  json.deadline         assigned_project.course_project_instance.end_date
end
