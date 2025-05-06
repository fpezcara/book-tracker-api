require "test_helper"
require_relative "../stubs/stub_google_books_api"
require_relative "../helpers/book_test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  include BookTestHelper

  class SearchActionTest < BooksControllerTest
    test "POST /books/search when no params are passed, it returns bad request" do
      post search_books_url, params: { book: {} }

      assert_response :bad_request
    end

    test "POST /books/search when invalid params are passed, it returns bad request" do
      post search_books_url, params: { book: { query: "", search_by: "" } }

      assert_response :bad_request
      assert_equal({ error: "Missing query or search_by parameters" }.to_json, response.body)
    end

    test "POST /books/search when valid params are passed, it returns success" do
      stub_book_found!("Harry Potter", books_response)
      post search_books_url, params: { book: { query: "Harry Potter", search_by: "title" } }

      assert_response :success
      ActionCable.server.broadcast "SearchChannel", { query: "Harry Potter", search_by: "title" }
      assert_broadcast_on("SearchChannel", query: "Harry Potter", search_by: "title")
      assert_broadcasts "SearchChannel", 2
    end
  end
end
