json.array! @course_project_instances do |course_project_instance|
  json.partial! 'api/v1/course_project_instances/info',
                course_project_instance:
end
