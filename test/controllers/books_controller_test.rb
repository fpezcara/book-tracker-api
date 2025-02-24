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
    test "GET /books returns an empty array when no books exist" do
       get :index

       assert_response :success
       assert_equal Book.all, []
     end

    test "GET /books returns all books when books exist" do
      book = Book.create!(@book_params)
      another_book = Book.create!(title: "Another title", isbn: "1234567860120")

      get :index

      assert_response :success
      assert_equal Book.all, [ book, another_book ]
    end
  end

  class CreateActionTest < BooksControllerTest
    test "POST /books with missing params returns bad request" do
      post :create, params: { book: {} }

      assert_response :bad_request
    end

    test "POST /books when title param is missing it returns bad request" do
      post :create, params: { book: { authors: [ "Test author" ], isbn: "0123456789123" } }

      assert_response :bad_request
    end

    test "POST /books when isbn param is missing it returns bad request" do
      post :create, params: { book: { authors: [ "Test author" ], title: "Test title" } }

      assert_response :bad_request
    end

    test "POST /books with valid params returns created" do
      post :create, params: { book: @book_params }

      assert_response :created
    end

    test "POST /books when book exists in db it returns it" do
      book = Book.create!(title: "Test Title", isbn: "1234567890123")

      post :create, params: { book: @book_params }

      assert_response :ok
      assert_equal response.body, book.to_json
    end

    test "POST /books creates a new book record" do
      post :create, params: { book: @book_params }
      created_book = Book.last
      response_body = JSON.parse(response.body)

      assert created_book.present?

      assert_equal response_body["title"], created_book.title
      assert_equal response_body["authors"], created_book.authors
      assert_equal response_body["isbn"], created_book.isbn
      assert_equal response_body["published_date"], created_book.published_date.to_s
      assert_equal response_body["page_count"], created_book.page_count
      assert_equal response_body["cover_image"], created_book.cover_image
    end

    test "POST /books returns the newly created book" do
      post :create, params: { book: @book_params }
      created_book = Book.last

      assert_equal response.body, created_book.to_json
    end

    test "POST /books with only required params creates a book" do
      post :create, params: { book: { title: "Test Title", isbn: "1234567891234" } }

      assert_response :created
      created_book = Book.last
      assert_equal "Test Title", created_book.title
      assert_equal "1234567891234", created_book.isbn
    end
  end

  class ShowActionTest < BooksControllerTest
    test "GET /books/:id when book does not exist it returns no books" do
      get :show, params: { id: "98adc1e3-e286-4632-9cd0-0520d5597a64" }

      assert_response :not_found
    end

    test "GET /books/:id when book exists it returns the right book" do
      book = Book.create(@book_params)

      get :show, params: { id: book.id }

      assert_response :ok
      assert_equal response.body, book.to_json
    end
  end

  class SearchActionTest < BooksControllerTest
    test "POST /books/search when book does not exist it returns no books" do
      stub_book_not_found!("874329742")

      post :search, params: { query: "874329742", search_by: "title" }

      assert_response :success
      assert_equal response.body, { data: [] }.to_json
    end

    test "POST /books/search when book exists it returns an array with books" do
      stub_book_found!("little women", books_response)

      post :search, params: { query: "little women", search_by: "title" }

      assert_response :success
      assert_equal response.body, { data: expected_books_response }.to_json
    end
  end
end
