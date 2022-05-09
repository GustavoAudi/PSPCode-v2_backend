FactoryGirl.define do
  factory :project do
    name    { Faker::Name.unique.name }
    process { create :psp_process }
  end
end
