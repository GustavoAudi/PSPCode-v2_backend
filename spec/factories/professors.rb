# frozen_string_literal: true

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

FactoryBot.define do
  factory :professor do
    email            { Faker::Internet.unique.email }
    first_name       { Faker::Name.first_name }
    last_name        { Faker::Name.last_name }
    additional_notes { Faker::Lorem.sentence }
    password         { Faker::Internet.password(min_length: 8) }
  end
end
