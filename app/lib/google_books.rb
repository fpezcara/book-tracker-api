# frozen_string_literal: true

require "faraday"

module GoogleBooks
  class Client
    BASE_URL = "https://www.googleapis.com/books/v1/volumes?q="
    ALLOWED_SEARCH_BY = %w[title author isbn]
    GOOGLE_BOOKS_API_KEY = Rails.application.credentials.google_books_api_key

    def fetch_books(query, search_by)
      unless ALLOWED_SEARCH_BY.include?(search_by)
        return { error: "Invalid search_by parameter" }
      end

      url = build_url(query, search_by)

      response = Faraday.get(url)
      # todo: probably will need to revise how many books we send back
      if response.success?
        data = JSON.parse(response.body)["items"]
        formatted_books = data.map { |book| formatted_data(book) }

        { data: formatted_books }
      else
        { error: "Request failed with status #{response.status}" }
      end
    end

    private
      def build_url(query, search_by)
        "#{BASE_URL}#{map_search_by(search_by)}:#{query}&orderBy=relevance&key=#{GOOGLE_BOOKS_API_KEY}"
      end

      def map_search_by(search_by)
        case search_by
        when "title"
          "intitle"
        when "author"
          "inauthor"
        when "isbn"
          "isbn"
        end
      end

      def formatted_data(book)
        {
          title: book["volumeInfo"]["title"],
          authors: book["volumeInfo"]["authors"],
          published_date: book["volumeInfo"]["publishedDate"],
          page_count: book["volumeInfo"]["pageCount"],
          cover_image: book["volumeInfo"]["imageLinks"]["thumbnail"],
          isbn: book["volumeInfo"]["industryIdentifiers"]&.first&.dig("identifier")
        }
      end
  end
end
