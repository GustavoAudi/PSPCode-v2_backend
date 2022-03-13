# == Schema Information
#
# Table name: users
#
#  id                             :integer          not null, primary key
#  email                          :string
#  encrypted_password             :string           default(""), not null
#  reset_password_token           :string
#  reset_password_sent_at         :datetime
#  remember_created_at            :datetime
#  sign_in_count                  :integer          default(0), not null
#  current_sign_in_at             :datetime
#  last_sign_in_at                :datetime
#  current_sign_in_ip             :inet
#  last_sign_in_ip                :inet
#  first_name                     :string           default("")
#  last_name                      :string           default("")
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  provider                       :string           default("email"), not null
#  uid                            :string           default(""), not null
#  tokens                         :json
#  approved_subjects              :text             default([]), is an Array
#  programming_language           :string
#  have_a_job                     :boolean
#  job_role                       :string
#  academic_experience            :string
#  programming_experience         :string
#  collegue_career_progress       :string
#  course_id                      :integer          not null
#  professor_id                   :integer
#  current_assigned_project_id    :integer
#  last_seen_event_notification   :datetime
#  last_seen_message_notification :datetime
#
# Indexes
#
#  index_users_on_course_id                    (course_id)
#  index_users_on_current_assigned_project_id  (current_assigned_project_id)
#  index_users_on_email                        (email) UNIQUE
#  index_users_on_professor_id                 (professor_id)
#  index_users_on_reset_password_token         (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider             (uid,provider) UNIQUE
#

require 'rails_helper'

describe User do
  describe 'validations' do
    subject { build :user }
    it { is_expected.to validate_presence_of(:email) }
    it { is_expected.to validate_presence_of(:course) }
    it { is_expected.to validate_presence_of(:professor) }
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }

    describe '#professor_of_same_course' do
      let!(:professor) { create :professor }
      let!(:course) { create :course }

      context 'when professor is blank' do
        let!(:user) { build :user, professor: nil }

        it 'does not raise NoMethodError' do
          expect { user.valid? }.not_to raise_error
        end
      end

      context 'when course is blank' do
        let!(:user) { build :user, course: nil }

        it 'does not raise NoMethodError' do
          expect { user.valid? }.not_to raise_error
        end
      end

      context 'when professor and course are not blank' do
        context 'when professor does not belong to the course' do
          let!(:user) { build :user }

          it 'raises professor validation' do
            ProfessorCourse.destroy_all
            expect(user.valid?).to be_falsey
            expect(user.errors[:professor]).to include 'Must belong to the same course'
          end
        end

        context 'when professor belongs to the course' do
          let!(:user) { build :user }

          it 'does not raise professor validation' do
            expect(user.valid?).to be_truthy
          end
        end
      end
    end

    describe '#email_user_professor_uniqueness' do
      let!(:email) { Faker::Internet.email }
      let!(:user)  { build :user, email: email }

      context 'when user is not taken by any user or professor' do
        it 'validates user' do
          expect(user).to be_valid
        end
      end

      context 'when user is already taken' do
        context 'when email is taken by a professor' do
          let!(:professor) { create :professor, email: email }

          it 'does not validate user' do
            expect(user.valid?).to be_falsey
            expect(user.errors[:email]).to include 'has already been taken'
          end
        end

        context 'when email is taken by a user' do
          let!(:another_user) { create :user, email: email }

          it 'does not validate user' do
            expect(user.valid?).to be_falsey
            expect(user.errors[:email]).to include 'has already been taken'
          end
        end
      end
    end
  end

  describe 'Callbacks' do
    describe 'before_create' do
      describe 'set_last_seen_values' do
        let(:user) do
          create :user, last_seen_event_notification: nil,
                        last_seen_message_notification: nil
        end

        it 'assigns last_seen_event_notification' do
          expect(user.last_seen_event_notification).not_to be nil
        end

        it 'assigns last_seen_message_notification' do
          expect(user.last_seen_message_notification).not_to be nil
        end
      end

      describe 'set_password' do
        let(:user) { create :user }

        it 'assigns and save password' do
          expect(user.encrypted_password.present?).to be_truthy
        end

        it 'assigns attr_accessor generated_password' do
          expect(user.generated_password.present?).to be_truthy
        end
      end
    end

    describe 'after_create' do
      describe 'send_welcome_email' do
        let(:user) { create :user }

        it 'have access to attr_accessor generated_password' do
          expect(user.generated_password.present?).to be_truthy
        end
      end
    end
  end

  describe 'ActAsEntityWithName' do
    context 'when user does not have either first or last name' do
      let(:user) { build :user, first_name: nil, last_name: nil }

      it 'does not return an error' do
        expect { user.name }.not_to raise_error
      end
    end

    context 'when user has both first and last name' do
      let(:user) { build :user, first_name: 'John', last_name: 'Doe' }
      it 'does not return an error' do
        expect { user.name }.not_to raise_error
      end

      it 'does not return an error' do
        expect(user.name).to eq("#{user.first_name} #{user.last_name}")
      end
    end
  end
end
