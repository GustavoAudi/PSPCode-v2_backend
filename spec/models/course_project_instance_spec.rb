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

require 'rails_helper'

describe CourseProjectInstance do
  describe 'Associations' do
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:course) }
  end

  describe 'Validations' do
    context '#valid_project_period_within_course' do
      let(:course) { create :course, start_date: 3.days.ago, end_date: Date.today + 5.days }

      context 'when project start_date is before course start_date' do
        let!(:course_project_instance) do
          build :course_project_instance, course:,
                                          start_date: course.start_date - 1.day,
                                          end_date: Date.today + 4.days
        end

        it 'does not create the entitiy' do
          expect(course_project_instance.valid?).to be_falsey
          expect(course_project_instance.errors[:invalid_time_period])
            .to include 'project dates should be contained within the course dates'
        end
      end

      context 'when project start_date is after course end_date' do
        let!(:course_project_instance) do
          build :course_project_instance, course:,
                                          start_date: course.end_date + 1.day,
                                          end_date: Date.today + 20.days
        end

        it 'does not create the entitiy' do
          expect(course_project_instance.valid?).to be_falsey
          expect(course_project_instance.errors[:invalid_time_period])
            .to include 'project dates should be contained within the course dates'
        end
      end

      context 'when project end_date is before course start_date' do
        let!(:course_project_instance) do
          build :course_project_instance, course:,
                                          start_date: course.start_date,
                                          end_date: course.start_date - 1.day
        end

        it 'does not create the entitiy' do
          expect(course_project_instance.valid?).to be_falsey
          expect(course_project_instance.errors[:invalid_time_period])
            .to include 'project dates should be contained within the course dates'
        end
      end

      context 'when project start_date is after course end_date' do
        let!(:course_project_instance) do
          build :course_project_instance, course:,
                                          start_date: course.start_date + 1.day,
                                          end_date: course.end_date + 1.day
        end

        it 'does not create the entitiy' do
          expect(course_project_instance.valid?).to be_falsey
          expect(course_project_instance.errors[:invalid_time_period])
            .to include 'project dates should be contained within the course dates'
        end
      end

      context 'when start_date and end_date of project are correct' do
        let!(:course_project_instance) do
          build :course_project_instance, course:,
                                          start_date: course.start_date + 1.day,
                                          end_date: course.end_date - 1.day
        end

        it 'does not raise error' do
          expect(course_project_instance.valid?).to be_truthy
        end
      end
    end

    context '#valid_project_period' do
      context 'when start_date is not before end_date' do
        let(:project) { create :project }
        let(:course) { create :course }
        let!(:course_project) do
          CourseProjectInstance.new start_date: course.start_date,
                                    end_date: course.start_date - 1.day,
                                    project:
        end

        it 'does not create the record' do
          expect(course_project.valid?).to be_falsey
        end

        it 'adds an error to the record' do
          course_project.valid?
          expect(course_project.errors[:invalid_time_period])
            .to include 'start_date should precede end_date'
        end
      end
    end

    describe 'counter_caches' do
      let(:course_project_instance) { create :course_project_instance }

      context 'when an assigned project changes its status' do
        context 'for assigned_projects' do
          it 'increase the counter for the arrival status' do
            expect { create(:assigned_project, course_project_instance:) }
              .to change { course_project_instance.reload.assigned_count }.by(1)
          end
        end

        context 'for working_projects' do
          let!(:assigned_project) do
            create(:assigned_project, course_project_instance:)
          end

          it 'increase the counter for the arrival status' do
            expect { assigned_project.update! status: :working }
              .to change { course_project_instance.reload.working_count }.by(1)
          end

          it 'decrease the counter for the old status' do
            expect { assigned_project.update! status: :working }
              .to change { course_project_instance.reload.assigned_count }.from(1).to(0)
          end
        end

        context 'for working projects' do
          let!(:assigned_project) do
            create(:assigned_project, course_project_instance:)
          end

          it 'increase the counter for the arrival status' do
            expect { assigned_project.update! status: :working }
              .to change { course_project_instance.reload.working_count }.by(1)
          end

          it 'decrease the counter for the old status' do
            expect { assigned_project.update! status: :working }
              .to change { course_project_instance.reload.assigned_count }.from(1).to(0)
          end
        end

        context 'for being_corrected projects' do
          let!(:assigned_project) do
            create(:assigned_project, course_project_instance:)
          end

          before { assigned_project.update! status: :working }

          it 'increase the counter for the arrival status' do
            expect { assigned_project.update! status: :being_corrected }
              .to change { course_project_instance.reload.being_corrected_count }.by(1)
          end

          it 'decrease the counter for the old status' do
            expect { assigned_project.update! status: :being_corrected }
              .to change { course_project_instance.reload.working_count }.from(1).to(0)
          end
        end

        context 'for approved projects' do
          let!(:assigned_project) do
            create(:assigned_project, course_project_instance:)
          end

          before do
            assigned_project.update! status: :working
            assigned_project.update! status: :being_corrected
          end

          it 'increase the counter for the arrival status' do
            expect { assigned_project.update! status: :approved }
              .to change { course_project_instance.reload.approved_count }.by(1)
          end

          it 'decrease the counter for the old status' do
            expect { assigned_project.update! status: :approved }
              .to change { course_project_instance.reload.being_corrected_count }.from(1).to(0)
          end
        end

        context 'for need_correction projects' do
          let!(:assigned_project) do
            create(:assigned_project, course_project_instance:)
          end

          before do
            assigned_project.update! status: :working
            assigned_project.update! status: :being_corrected
          end

          it 'increase the counter for the arrival status' do
            expect { assigned_project.update! status: :need_correction }
              .to change { course_project_instance.reload.need_correction_count }.by(1)
          end

          it 'decrease the counter for the old status' do
            expect { assigned_project.update! status: :need_correction }
              .to change { course_project_instance.reload.being_corrected_count }.from(1).to(0)
          end
        end
      end
    end
  end
end
