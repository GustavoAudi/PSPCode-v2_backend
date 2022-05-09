# == Schema Information
#
# Table name: assigned_projects
#
#  id                         :integer          not null, primary key
#  course_project_instance_id :integer          not null
#  user_id                    :integer          not null
#  status                     :integer
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  process_id                 :integer
#
# Indexes
#
#  index_assigned_projects_on_course_project_instance_id  (course_project_instance_id)
#  index_assigned_projects_on_process_id                  (process_id)
#  index_assigned_projects_on_user_id                     (user_id)
#

FactoryGirl.define do
  factory :assigned_project do
    course_project_instance
    user { create :user, course: course_project_instance.course }
  end
end
