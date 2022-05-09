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

require 'rails_helper'

describe ProfessorCourse do
  describe 'Associations' do
    it { is_expected.to belong_to(:professor) }
    it { is_expected.to belong_to(:course) }
  end
  describe 'Validations' do
    # it { is_expected.to validate_presence_of(:professor_id) }
    # it { is_expected.to validate_presence_of(:course_id) }
  end
end
