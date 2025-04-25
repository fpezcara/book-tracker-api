FactoryBot.define do
  factory :book do
    title { Faker::Book.title }
    authors { [ Faker::Book.author ] }
    published_date { Faker::Date.backward(days: 365) }
    isbn { Faker::Number.number(digits: 13).to_s }
    page_count { Faker::Number.between(from: 100, to: 1000) }
    cover_image { Faker::LoremFlickr.image(size: "50x60", search_terms: [ "books" ]) }
  end
end
