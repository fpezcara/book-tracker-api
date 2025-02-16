require "test_helper"

class GoogleBooksServiceTest < ActiveSupport::TestCase
  def setup
    @query = "first day"
    @search_by = "title"
    @api_key = Rails.application.credentials.google_books_api_key
    @base_url = "https://www.googleapis.com/books/v1/volumes?q="
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
    }.to_json

    stub_request(:get, "#{@base_url}intitle:#{@query}&orderBy=relevance&key=#{@api_key}").
      with(
        headers: {
              "Accept"=>"*/*",
              "Accept-Encoding"=>"gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent"=>"Faraday v2.12.2"
        }).to_return(status: 200, body: response_body, headers: {})

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

    books = GoogleBooksService.fetch_books(@query, @search_by)

    assert_equal({ data: expected_response }, books)
  end

  def test_fetch_books_failure
    stub_request(:get, "#{@base_url}intitle:#{@query}&orderBy=relevance&key=#{@api_key}")
      .to_return(status: 500, body: "", headers: {})

    books = GoogleBooksService.fetch_books(@query, @search_by)

    assert_equal({ error: "Request failed with status 500" }, books)
  end

  def test_fetch_books_with_wrong_search_by_option
    search_by = "wrong_search_by"

    books = GoogleBooksService.fetch_books(@query, search_by)

    assert_equal({ error: "Invalid search_by parameter" }, books)
  end
end
