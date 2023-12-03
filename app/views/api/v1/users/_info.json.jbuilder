# frozen_string_literal: true

json.id                   user.id
json.first_name           user.first_name
json.last_name            user.last_name
json.email                user.email
json.member_since         user.created_at
json.role                 'student'
json.approved_subjects user.approved_subjects
json.programming_language user.programming_language
json.have_a_job user.have_a_job
json.job_role user.job_role
json.programming_experience user.programming_experience
json.academic_experience user.academic_experience
json.collegue_career_progress user.collegue_career_progress
json.course do
  json.partial! 'api/v1/courses/info', course: user.course
end
