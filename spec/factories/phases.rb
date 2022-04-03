# frozen_string_literal: true

# == Schema Information
#
# Table name: phases
#
#  id          :integer          not null, primary key
#  name        :string           not null
#  description :string
#  order       :integer
#  first       :boolean          default(FALSE)
#  last        :boolean          default(FALSE)
#

FactoryGirl.define do
  factory :phase do
    name { Faker::Name.unique.name }
    description { Faker::Lorem.sentence }
    order { Phase.count + 1 }
  end
end
