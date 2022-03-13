json.id               course_project_instance.id
json.name             course_project_instance.name
json.start_date       course_project_instance.start_date
json.deadline         course_project_instance.end_date
json.process do
  json.partial! 'api/v1/psp_processes/info', process: course_project_instance.project.process
end

json.working course_project_instance.students_working
json.approved course_project_instance.approved_count
json.to_correct course_project_instance.being_corrected_count
json.not_assigned course_project_instance.students_not_assigned
