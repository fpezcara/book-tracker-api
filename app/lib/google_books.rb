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

        formatted_books = data.map { |book| formatted_data(book) } if !data.empty?

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
        return unless book["volumeInfo"]

        book_data = book["volumeInfo"]
        industry_identifiers = book_data["industryIdentifiers"] || []
        isbn_13 = industry_identifiers.find { |id| id["type"] == "ISBN_13" }&.dig("identifier")

        isbn_13 = industry_identifiers.find { |id| id["type"] == "ISBN_13" }&.dig("identifier")

        {
          title: book_data["title"] || "No title available",
          authors: book_data["authors"] || [ "Unknown author" ],
          published_date: book_data["publishedDate"] || "Unknown",
          page_count: book_data["pageCount"] || 0,
          cover_image: book_data.dig("imageLinks", "thumbnail") || "No image available",
          isbn: isbn_13 || industry_identifiers.first&.dig("identifier") || "No ISBN available"
        }
      end
  end
end
