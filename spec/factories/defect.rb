# frozen_string_literal: true

FactoryBot.define do
  factory :defect do
    discovered_time { Time.now }
    phase_instance { create :phase_instance }
    phase_injected { create :phase }
    defect_type { 'Assignment' }
    fixed_time { Time.now + 2.minutes }
    description { Faker::Lorem.sentence }
  end
end
