# == Schema Information
#
# Table name: courses
#
#  id               :integer          not null, primary key
#  start_date       :date             not null
#  end_date         :date             not null
#  description      :string
#  additional_notes :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  name             :string           not null
#

class Course < ApplicationRecord
  # Students assigned to a course
  has_many :students, class_name: 'User'

  # Professors of a course
  has_many :professor_courses
  has_many :professors, through: :professor_courses

  # Projects of the course
  has_many :course_projects, class_name: 'CourseProjectInstance'
  # Use it to render it in RailsAdmin
  has_many :projects, through: :course_projects

  validates :name, :start_date, :end_date, presence: true
  validate :valid_course_period

  accepts_nested_attributes_for :course_projects
  accepts_nested_attributes_for :professor_courses,
                                allow_destroy: true

  def contains_time_period?(st_dt, end_dt)
    start_date <= st_dt && st_dt <= end_date &&
      start_date <= end_dt && end_dt <= end_date
  end

  private

  def valid_course_period
    return unless start_date.present? && end_date.present?
    errors.add(:wrong_valid_period,
               'start_date should precede end_date') if (start_date >= end_date)
  end
end
