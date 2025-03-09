require "test_helper"
require_relative "../stubs/stub_google_books_api"
require_relative "../helpers/book_test_helper"

class BooksControllerTest < ActionController::TestCase
  include BookTestHelper

  def setup
    @book_params = { title: "Test Title", authors: [ "Test author" ], published_date: "2025-02-16",
    isbn: "1234567890123", page_count: 235, cover_image: "fake-image.url" }
  end

  class IndexActionTest < BooksControllerTest
    test "GET /books returns an empty array, when no books exist" do
      get :index

      assert_response :success
      assert_equal [], Book.all
    end

    test "GET /books returns all books, when books exist" do
      book = Book.create!(@book_params)
      another_book = Book.create!(title: "Another title", isbn: "1234567860120")

      get :index

      assert_response :success
      assert_equal [ book, another_book ], Book.all
    end
  end

  class CreateActionTest < BooksControllerTest
    test "POST /books with missing params, returns bad request" do
      post :create, params: { book: {} }

      assert_response :bad_request
    end

    test "POST /books when title param is missing, it returns bad request" do
      post :create, params: { book: { authors: [ "Test author" ], isbn: "0123456789123" } }

      assert_response :bad_request
    end

    test "POST /books when isbn param is missing, it returns bad request" do
      post :create, params: { book: { authors: [ "Test author" ], title: "Test title" } }

      assert_response :bad_request
    end

    test "POST /books with valid params, it returns created" do
      post :create, params: { book: @book_params }

      assert_response :created
    end

    test "POST /books when book exists in db, it returns it" do
      book = Book.create!(title: "Test Title", isbn: "1234567890123")

      post :create, params: { book: @book_params }

      assert_response :ok
      assert_equal book.to_json, response.body
    end

    test "POST /books when valid params are passed, it creates a new book record" do
      post :create, params: { book: @book_params }
      created_book = Book.last
      response_body = JSON.parse(response.body)

      assert created_book.present?

      assert_equal created_book.title, response_body["title"]
      assert_equal created_book.authors, response_body["authors"]
      assert_equal created_book.isbn, response_body["isbn"]
      assert_equal created_book.published_date.to_s, response_body["published_date"]
      assert_equal created_book.page_count, response_body["page_count"]
      assert_equal created_book.cover_image, response_body["cover_image"]
    end

    test "POST /books when valid params are passed, it returns the newly created book" do
      post :create, params: { book: @book_params }
      created_book = Book.last

      assert_equal response.body, created_book.to_json
    end

    test "POST /books with only required params, it creates a book" do
      post :create, params: { book: { title: "Test Title", isbn: "1234567891234" } }

      assert_response :created
      created_book = Book.last
      assert_equal created_book.title, "Test Title"
      assert_equal created_book.isbn, "1234567891234"
    end
  end

  class ShowActionTest < BooksControllerTest
    test "GET /books/:id when book does not exist in db, it returns no books" do
      get :show, params: { id: "98adc1e3-e286-4632-9cd0-0520d5597a64" }

      assert_response :not_found
    end

    test "GET /books/:id when book exists in db, it returns the right book" do
      book = Book.create(@book_params)

      get :show, params: { id: book.id }

      assert_response :ok
      assert_equal book.to_json, response.body
    end
  end

  class SearchActionTest < BooksControllerTest
    test "POST /books/search when book does not exist, it returns no books" do
      stub_book_not_found!("874329742")

      post :search, params: { book: { query: "874329742", search_by: "title" } }

      assert_response :success
      assert_equal({ data: [] }.to_json, response.body)
    end

    test "POST /books/search when search_by param is not permitted, it raises an error" do
    post :search, params: { book: { query: "little women", search_by: "invalid search attribute" } }

    # todo: eupdate code to get a bad request when the params is not permitted
    assert_response :bad_request
    assert_equal({ error: "Invalid search_by parameter" }.to_json, response.body)
  end

    test "POST /books/search when book exists, it returns an array with books" do
      stub_book_found!("little women", books_response)

      post :search, params: { book: { query: "little women", search_by: "title" } }

      assert_response :success
      assert_equal({ data: expected_books_response }.to_json, response.body)
    end
  end

  class UpdateActionTest < BooksControllerTest
    test "PATCH /books/:id with missing id param, it returns bad request" do
      patch :update, params:  { id: "" }

      assert_response :bad_request
      assert_equal response.body, { "message": "param is missing or the value is empty or invalid: id" }.to_json
    end

    test "PATCH /books/:id with unknown id returns not found" do
      patch :update, params:  { id: "unknown_id" }

      assert_response :not_found
    end

    test "PATCH /books/:id when no book param is passed, it returns bad request" do
      book = Book.create(@book_params)

      patch :update, params:  { id: book.id }

      assert_response :bad_request
      assert_equal({ message: "param is missing or the value is empty or invalid: book" }.to_json, response.body)
    end

    test "PATCH /books/:id when attribute to update is passed, it updates the record" do
      new_title = "Little Women"
      new_isbn = "1293829414232"

      book = Book.create(@book_params)

      patch :update, params:  { id: book.id, book: { title: new_title, isbn: new_isbn } }

      assert_response :success
      assert_includes response.body, new_title
      assert_includes response.body, new_isbn
    end
  end

  class DestroyActionTest < BooksControllerTest
    test "DELETE /books/:id when no id is passed, it returns bad request" do
      delete :destroy, params:  { id: "" }

      assert_response :bad_request
      assert_equal({ "message": "param is missing or the value is empty or invalid: id" }.to_json, response.body)
    end

    test "DELETE /books/:id when unknown id is passed, it returns not found" do
      delete :destroy, params:  { id: "unknown_id" }

      assert_response :not_found
    end

    test "DELETE /books/:id when id is passed, it deletes book" do
      book = Book.create(@book_params)

      delete :destroy, params:  { id: book.id }

      assert_response(204)
    end
  end
end
