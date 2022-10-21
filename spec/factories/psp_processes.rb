# frozen_string_literal: true

# == Schema Information
#
# Table name: psp_processes
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  has_plan_time :boolean          default(FALSE)
#  has_plan_loc  :boolean          default(FALSE)
#  has_pip       :boolean          default(FALSE)
#

FactoryBot.define do
  factory :psp_process do
    name { Faker::Name.unique.name }
  end
end
