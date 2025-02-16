FactoryBot.define do
  factory :book do
    title { "The First Day of Spring" }
    authors { [ "Nancy Tucker" ] }
    published_date { "boo" }
    isbn { "9781453721132" }
    page_count { 328 }
    cover_image { "http://books.google.com/books/content?id=8drgDwAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api" }
  end
end
