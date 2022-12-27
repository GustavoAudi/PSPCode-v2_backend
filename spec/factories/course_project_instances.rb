# frozen_string_literal: true

# == Schema Information
#
# Table name: course_project_instances
#
#  id                      :integer          not null, primary key
#  project_id              :integer          not null
#  course_id               :integer          not null
#  start_date              :date             not null
#  end_date                :date             not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  name                    :string
#  assigned_count          :integer          default(0)
#  working_count           :integer          default(0)
#  being_corrected_count   :integer          default(0)
#  approved_count          :integer          default(0)
#  need_correction_count   :integer          default(0)
#  assigned_projects_count :integer          default(0)
#
# Indexes
#
#  index_course_project_instances_on_course_id   (course_id)
#  index_course_project_instances_on_end_date    (end_date)
#  index_course_project_instances_on_project_id  (project_id)
#

FactoryBot.define do
  factory :course_project_instance do
    project
    course     { create :course, start_date: Date.today, end_date: Date.today + 10.days }
    start_date { Date.today + 1.day }
    end_date   { Date.today + 2.days }
  end
end
