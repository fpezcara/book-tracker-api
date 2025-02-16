# frozen_string_literal: true

require "faraday"
# todo: add validation so it can only be called with "intitle", "inauthor" or "isbn"
class GoogleBooksService
  BASE_URL = "https://www.googleapis.com/books/v1/volumes?q="
  ALLOWED_SEARCH_BY = %w[intitle inauthor isbn]

  def self.fetch_books(query, search_by)
    unless ALLOWED_SEARCH_BY.include?(search_by)
      return { error: "Invalid search_by parameter" }
    end

    url = build_url(query, search_by)

    response = Faraday.get(url)

    if response.success?
      { data: JSON.parse(response.body) }
    else
      { error: "Request failed with status #{response.status}" }
    end
  end

  private
    def self.build_url(query, search_by)
      "#{BASE_URL}#{search_by}:#{query}&orderBy=relevance&key=#{Rails.application.credentials.google_books_api_key}"
    end
end
