require "test_helper"

class GoogleBooksServiceTest < ActiveSupport::TestCase
  def setup
    @query = "harry potter"
    @search_by = "intitle"
    @api_key = Rails.application.credentials.google_books_api_key
    @base_url = "https://www.googleapis.com/books/v1/volumes?q="
  end


  def test_fetch_books_success
    response_body = {
      "items" => [
        {
          "volumeInfo" => {
            "title" => "Harry Potter and the Sorcerer's Stone",
            "authors" => [ "J.K. Rowling" ],
            "publishedDate" => "1997-06-26",
            "pageCount" => 309,
            "imageLinks" => {
              "thumbnail" => "https://example.com/thumbnail.jpg"
            },
            "industryIdentifiers" => [
              { "identifier" => "9780747532699" }
            ]
          }
        }
      ]
    }.to_json

    stub_request(:get, "#{@base_url}#{@search_by}:#{@query}&orderBy=relevance&key=#{@api_key}").
      with(
        headers: {
              "Accept"=>"*/*",
              "Accept-Encoding"=>"gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
              "User-Agent"=>"Faraday v2.12.2"
        }).to_return(status: 200, body: response_body, headers: {})



    books = GoogleBooksService.fetch_books(@query, @search_by)

    assert_equal({ data: JSON.parse(response_body) }, books)
  end

  def test_fetch_books_failure
    stub_request(:get, "#{@base_url}#{@search_by}:#{@query}&orderBy=relevance&key=#{@api_key}")
      .to_return(status: 500, body: "", headers: {})

    books = GoogleBooksService.fetch_books(@query, @search_by)

    assert_equal({ error: "Request failed with status 500" }, books)
  end
end
