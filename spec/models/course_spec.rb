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

require 'rails_helper'

describe Course do
  describe 'Associations' do
    it { is_expected.to have_many(:professor_courses) }
    it { is_expected.to have_many(:professors).through(:professor_courses) }
    it { is_expected.to have_many(:course_projects) }
    it { is_expected.to have_many(:students) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:start_date) }
    it { is_expected.to validate_presence_of(:end_date) }

    context '#valid_course_period' do
      context 'when start_date is not before end_date' do
        let!(:course) do
          build :course, start_date: Date.today, end_date: Date.yesterday
        end

        it 'does not create the record' do
          expect(course.valid?).to be_falsey
        end

        it 'adds an error to the record' do
          course.valid?
          expect(course.errors[:wrong_valid_period])
            .to include 'start_date should precede end_date'
        end
      end
    end
  end
end
