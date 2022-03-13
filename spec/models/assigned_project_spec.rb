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

require 'rails_helper'

describe AssignedProject do
  describe 'Associations' do
    it { is_expected.to have_many(:project_deliveries).dependent(:destroy) }
    it { is_expected.to have_many(:past_statuses) }
    it { is_expected.to have_many(:messages) }
    it { is_expected.to belong_to(:course_project_instance) }
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:process) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_presence_of(:course_project_instance) }

    describe 'user_course_project_instance_consistency' do
      let(:user) { create :user }
      let(:course) { create :course }
      let(:course_project_instance) { create :course_project_instance, course: course }
      let(:assigned_project) do
        build :assigned_project, course_project_instance: course_project_instance,
                                 user: user
      end

      context 'when user does not belong to the course from which the project want to be assigned' do
        it 'does not validate record' do
          expect(assigned_project.valid?).to be_falsey
          expect(assigned_project.errors[:user]).to include 'Must belong to the course'
        end
      end

      context 'when user belongs to the course from which the project want to be assigned' do
        before do
          user.professor.courses << course
          user.update! course: course
        end

        it 'does not validate record' do
          expect(assigned_project.valid?).to be_truthy
        end
      end
    end

    describe 'status_flow' do
      let!(:assigned_project) { create :assigned_project }
      context 'when current_status is assigned' do
        context 'when new status is other than working' do
          it 'raise an error' do
            assigned_project.status = :approved
            expect(assigned_project.valid?).to be_falsey
            expect(assigned_project.errors[:status]).to include 'unpermitted status flow'
          end
        end

        context 'when new status is working' do
          it 'does not raise an error' do
            assigned_project.status = :working
            expect(assigned_project.valid?).to be_truthy
          end
        end
      end

      context 'when current_status is working' do
        before { assigned_project.update! status: :working }

        context 'when new status is other than being_corrected' do
          it 'raise an error' do
            assigned_project.status = :approved
            expect(assigned_project.valid?).to be_falsey
            expect(assigned_project.errors[:status]).to include 'unpermitted status flow'
          end
        end

        context 'when new status is being_corrected' do
          it 'does not raise an error' do
            assigned_project.status = :being_corrected
            expect(assigned_project.valid?).to be_truthy
          end
        end
      end

      context 'when current_status is being_corrected' do
        before do
          assigned_project.update! status: :working
          assigned_project.update! status: :being_corrected
        end

        context 'when new status is other than being_corrected' do
          it 'raise an error' do
            assigned_project.status = :working
            expect(assigned_project.valid?).to be_falsey
            expect(assigned_project.errors[:status]).to include 'unpermitted status flow'
          end
        end

        context 'when new status is approved' do
          it 'does not raise an error' do
            assigned_project.status = :being_corrected
            expect(assigned_project.valid?).to be_truthy
          end
        end

        context 'when new status is need_correction' do
          it 'does not raise an error' do
            assigned_project.status = :being_corrected
            expect(assigned_project.valid?).to be_truthy
          end
        end
      end

      context 'when current_status is approved' do
        before do
          assigned_project.update! status: :working
          assigned_project.update! status: :being_corrected
          assigned_project.update! status: :approved
        end

        [:assigned, :working, :being_corrected, :need_correction].each do |status|
          context 'when trying to assign a new state' do
            it 'raise an eror' do
              assigned_project.status = status
              expect(assigned_project.valid?).to be_falsey
              expect(assigned_project.errors[:status]).to include 'unpermitted status flow'
            end
          end
        end
      end

      context 'when current_status is need_correction' do
        before do
          assigned_project.update! status: :working
          assigned_project.update! status: :being_corrected
          assigned_project.update! status: :need_correction
        end

        context 'when new status is other than working' do
          it 'raise an error' do
            assigned_project.status = :approved
            expect(assigned_project.valid?).to be_falsey
            expect(assigned_project.errors[:status]).to include 'unpermitted status flow'
          end
        end

        context 'when new status is working' do
          it 'does not raise an error' do
            assigned_project.status = :working
            expect(assigned_project.valid?).to be_truthy
          end
        end
      end
    end
  end

  describe 'callbacks' do
    describe 'before_create' do
      describe '#assign_process' do
        let(:course)  { create :course }
        let(:user)    { create :user, course: course }
        let(:process) { create :psp_process }
        let(:project) { create :project, process: process }
        let(:course_project_instance) do
          create :course_project_instance,
                 project: project,
                 course: course,
                 start_date: course.start_date,
                 end_date: course.end_date - 1.day
        end
        let(:assigned_project) do
          build :assigned_project,
                user: user,
                course_project_instance: course_project_instance
        end

        it 'assigns correct process' do
          assigned_project.save!
          expect(assigned_project.process).to eq process
        end
      end
    end
  end
end
