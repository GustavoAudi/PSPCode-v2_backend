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

FactoryGirl.define do
  factory :course do
    name             { "Course #{Faker::Number.between(1900, 2018)}" }
    start_date       { Date.today }
    end_date         { Faker::Date.forward(23) }
    description      { Faker::Lorem.sentence }
    additional_notes { Faker::Lorem.sentence }
  end
end
