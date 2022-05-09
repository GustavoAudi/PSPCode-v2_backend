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

FactoryGirl.define do
  factory :user do
    email                { Faker::Internet.unique.email }
    first_name           { Faker::Name.first_name }
    last_name            { Faker::Name.last_name }
    programming_language { 'Ruby' }
    have_a_job           { false }
    password             { Faker::Internet.password(8) }
    uid                  { Faker::Number.unique.number(10) }
    professor
    course

    after(:build) do |user|
      user.course.professors << user.professor if user.course.present? && user.professor.present?
      user.send(:set_last_seen_values)
    end
  end

  trait :with_fb do
    password nil
    email nil
    provider 'facebook'
  end
end
