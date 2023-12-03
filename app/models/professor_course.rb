# frozen_string_literal: true

# == Schema Information
#
# Table name: professor_courses
#
#  id           :integer          not null, primary key
#  professor_id :integer          not null
#  course_id    :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_professor_courses_on_course_id     (course_id)
#  index_professor_courses_on_professor_id  (professor_id)
#

class ProfessorCourse < ApplicationRecord
  belongs_to :professor
  belongs_to :course

  validates :professor, :course, presence: true
  validates :professor, uniqueness: { scope: :course }
end
