# frozen_string_literal: true

API_KEY = Rails.application.credentials.google_books_api_key
BASE_URL = "https://www.googleapis.com/books/v1/volumes?q="

def stub_book_found!(query, response_body)
  stub_request(:get, "#{BASE_URL}intitle:#{query}&orderBy=relevance&key=#{API_KEY}").
    with(
      headers: {
            "Accept"=>"*/*",
            "Accept-Encoding"=>"gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
            "User-Agent"=>"Faraday v2.12.2"
      }).to_return(status: 200, body: response_body, headers: {})
end

def stub_bad_request!(query)
  stub_request(:get, "#{BASE_URL}intitle:#{query}&orderBy=relevance&key=#{API_KEY}")
    .to_return(status: 500, body: "", headers: {})
end
