# == Schema Information
#
# Table name: professors
#
#  id                             :integer          not null, primary key
#  email                          :string           default(""), not null
#  encrypted_password             :string           default(""), not null
#  reset_password_token           :string
#  reset_password_sent_at         :datetime
#  remember_created_at            :datetime
#  sign_in_count                  :integer          default(0), not null
#  current_sign_in_at             :datetime
#  last_sign_in_at                :datetime
#  current_sign_in_ip             :inet
#  last_sign_in_ip                :inet
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  first_name                     :string
#  last_name                      :string
#  additional_notes               :string
#  provider                       :string           default("email"), not null
#  uid                            :string           default(""), not null
#  tokens                         :json
#  last_seen_event_notification   :datetime
#  last_seen_message_notification :datetime
#
# Indexes
#
#  index_professors_on_email                 (email) UNIQUE
#  index_professors_on_reset_password_token  (reset_password_token) UNIQUE
#  index_professors_on_uid_and_provider      (uid,provider) UNIQUE
#

require 'rails_helper'

RSpec.describe Professor do
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    describe '#email_user_professor_uniqueness' do
      let!(:email) { Faker::Internet.email }
      let!(:professor)  { build :professor, email: email }

      context 'when professor is not taken by any professor or professor' do
        it 'validates professor' do
          expect(professor).to be_valid
        end
      end

      context 'when email is already taken' do
        context 'when email is taken by a user' do
          let!(:user) { create :user, email: email }

          it 'does not validate professor' do
            expect(professor.valid?).to be_falsey
            expect(professor.errors[:email]).to include 'has already been taken'
          end
        end

        context 'when email is taken by another professor' do
          let!(:another_professor) { create :professor, email: email }

          it 'does not validate professor' do
            expect(professor.valid?).to be_falsey
            expect(professor.errors[:email]).to include 'has already been taken'
          end
        end
      end
    end
  end

  describe 'Associations' do
    it { is_expected.to have_many(:professor_courses) }
    it { is_expected.to have_many(:courses).through(:professor_courses) }
  end

  describe 'Callbacks' do
    describe 'before_create' do
      describe 'set_last_seen_values' do
        let(:professor) do
          create :professor, last_seen_event_notification: nil,
                             last_seen_message_notification: nil
        end

        it 'assigns last_seen_event_notification' do
          expect(professor.last_seen_event_notification).not_to be nil
        end

        it 'assigns last_seen_message_notification' do
          expect(professor.last_seen_message_notification).not_to be nil
        end
      end
    end
  end

  describe 'ActAsEntityWithName' do
    context 'when professor does not have either first or last name' do
      let(:professor) { build :professor, first_name: nil, last_name: nil }

      it 'does not return an error' do
        expect { professor.name }.not_to raise_error
      end
    end

    context 'when professor has both first and last name' do
      let(:professor) { build :professor, first_name: 'John', last_name: 'Doe' }
      it 'does not return an error' do
        expect { professor.name }.not_to raise_error
      end

      it 'does not return an error' do
        expect(professor.name).to eq("#{professor.first_name} #{professor.last_name}")
      end
    end
  end
end
