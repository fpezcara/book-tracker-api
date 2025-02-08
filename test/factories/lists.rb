FactoryBot.define do
  factory :list do
    name { "Reading" }
    association :user
  end
end
