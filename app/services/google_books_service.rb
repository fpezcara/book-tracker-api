# frozen_string_literal: true

require "faraday"

class GoogleBooksService
  BASE_URL = "https://www.googleapis.com/books/v1/volumes?q="

  def self.fetch_books(query, search_by)
    puts "Queryyyy, search_byyyy", query

    url = build_url(query, search_by)

    puts "url", url

    response = Faraday.get(url)

    if response.success?
      JSON.parse(response.body)
    else
      raise "Request failed with status #{response.status}"
    end
  end

    private
      def self.build_url(query, search_by)
        "#{BASE_URL}#{search_by}:#{query}&orderBy=relevance&key=#{Rails.application.credentials.google_books_api_key}"
      end
end
