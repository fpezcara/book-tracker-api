require "test_helper"

class BooksControllerTest < ActionController::TestCase
  def setup
    @book_params = { title: "Test Title", authors: [ "Test author" ], published_date: "2025-02-16",
isbn: "12345678901234", page_count: 235, cover_image: "fake-image.url" }
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
      post :create,

      params: { book: @book_params }

      assert_response :created
    end

    test "POST /books creates a new book record" do
   post :create, params: { book: @book_params }
   created_book = Book.last


   assert created_book.present?
   assert_equal @book_params[:title], created_book.title
   assert_equal @book_params[:authors], created_book.authors
   assert_equal @book_params[:isbn], created_book.isbn
   assert_equal @book_params[:published_date], created_book.published_date.to_s
   assert_equal @book_params[:page_count], created_book.page_count
   assert_equal @book_params[:cover_image], created_book.cover_image
 end

    test "POST /books returns the newly created book" do
      post :create, params: { book: @book_params }
      created_book = Book.last

      assert_equal response.body, created_book.to_json
    end

    test "POST /books with only required params creates a book" do
      post :create, params: { book: { title: "Test Title", isbn: "12345678901234" } }

      assert_response :created
      created_book = Book.last
      assert_equal "Test Title", created_book.title
      assert_equal "12345678901234", created_book.isbn
    end
  end
end
