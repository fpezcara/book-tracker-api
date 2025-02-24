require "test_helper"
require_relative "../stubs/stub_google_books_api"

class GoogleBooksTest < ActiveSupport::TestCase
  def setup
    @query = "first day"
    @search_by = "title"
    @google_books_client = GoogleBooks::Client.new
  end


  def test_fetch_books_success
    response_body = {
      "items" => [
        {
          "volumeInfo" => {
            "title" => "Jake's First Day",
            "authors" => [ "Twinkl Originals" ],
            "publishedDate" => "2019-05-29",
            "pageCount" => 18,
            "imageLinks" => {
              "thumbnail" => "http://books.google.com/books/content?id=CRgrDwAAQBAJ\u0026printsec=frontcover\u0026img=1\u0026zoom=1\u0026edge=curl\u0026source=gbs_api"
            },
            "industryIdentifiers" => [
              { "identifier" => "9780241322741" }
            ]
          }
        }
      ]
    }

    stub_book_found!(@query, response_body)

    expected_response = [
        {
           title: "Jake's First Day",
            authors:  [ "Twinkl Originals" ],
            published_date: "2019-05-29",
            page_count: 18,
            cover_image: "http://books.google.com/books/content?id=CRgrDwAAQBAJ\u0026printsec=frontcover\u0026img=1\u0026zoom=1\u0026edge=curl\u0026source=gbs_api",
            isbn: "9780241322741"
        }
      ]

    books = @google_books_client.fetch_books(@query, @search_by)

    assert_equal({ data: expected_response }, books)
  end

  def test_fetch_books_failure
    stub_bad_request!(@query)

    books = @google_books_client.fetch_books(@query, @search_by)

    assert_equal({ error: "Request failed with status 500" }, books)
  end

  def test_fetch_books_with_wrong_search_by_option
    search_by = "wrong_search_by"

    books = @google_books_client.fetch_books(@query, search_by)

    assert_equal({ error: "Invalid search_by parameter" }, books)
  end
end
