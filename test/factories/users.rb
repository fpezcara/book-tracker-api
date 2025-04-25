FactoryBot.define do
  factory :user do
    sequence(:email_address) { Faker::Internet.email  }
    password { "password" }
    password_confirmation { password }
    id { Faker::Number.number(digits: 5).to_s }
  end
end
