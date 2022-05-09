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

class CourseProjectInstance < ApplicationRecord
  belongs_to :project
  belongs_to :course
  has_many :assigned_projects, dependent: :destroy
  has_many :students, through: :course

  validates :start_date, :end_date, :project, :course, presence: true
  validate :valid_project_period
  validate :valid_project_period_within_course

  before_create :assign_name

  def valid_project_period_within_course
    return if course.blank? || course.contains_time_period?(start_date, end_date)

    errors.add(:invalid_time_period,
               'project dates should be contained within the course dates')
  end

  def valid_project_period
    return unless start_date.present? && end_date.present?

    if start_date >= end_date
      errors.add(:invalid_time_period,
                 'start_date should precede end_date')
    end
  end

  def students_working
    working_count + assigned_count + need_correction_count
  end

  def students_not_assigned
    students.count - assigned_projects_count
  end

  def assign_name
    self.name = project.name
  end
end
