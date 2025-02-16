class BooksController < ApplicationController
  # Skip authentication for now
  allow_unauthenticated_access
  skip_before_action :verify_authenticity_token

  attr_accessor :book

  def index
    # todo: to get all books
  end

  # todo: this endpoint will be called with all the details to save the book
  def create
    @book = Book.create(book_params)

    if @book.save!
      render json: @book, status: :created
    end
  end

  def show
    "I'm actually working"
    # to get one specific book - is this needed
  end

  # todo: this needs to return a list of books (first 10 probably)
  def search
    GoogleBooksService.fetch_books(query, search_by)
    # to create proxy to call the google api service
  end

  def update
    # to update a book
  end

  def destroy
    # to delete a book
  end

  private

    def book_params
      params.require(:book).permit(:title, { authors: [] }, :published_date, :isbn, :page_count, :cover_image)
    end
end
