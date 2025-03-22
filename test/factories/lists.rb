FactoryBot.define do
  factory :list do
    name { "Fiction" }
    association :user
  end
end
