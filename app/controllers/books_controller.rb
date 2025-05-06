class BooksController < ApplicationController
  # Skip authentication for now
  allow_unauthenticated_access
  skip_before_action :verify_authenticity_token
  before_action :set_book, only: %i[show update destroy]

  attr_accessor :book

  def index
    render json: Book.all
  end

  def create
    @book = Book.find_by(isbn: params.require("book")["isbn"])

    if @book
      render json: @book, status: :ok
    else
      @book = Book.create!(book_params)
      if @book.save!
        render json: @book, status: :created
      end
    end
  end

  def show
    render json: @book
  end

  # todo: this needs to return a list of books (first 10 probably)
  # https://developers.google.com/books/docs/v1/using#pagination
  def search
    permitted_params = params[:book] ? params.require(:book).permit(:query, :search_by): {}
    query = permitted_params[:query]
    search_by = permitted_params[:search_by]

    if query.blank? || search_by.blank?
      render json: { error: "Missing query or search_by parameters" }, status: :bad_request
      return
    end

    client = GoogleBooks::Client.new
    books = client.fetch_books(query, search_by)

    Rails.logger.info "/books/search endpoint called"

    if books[:error]
      Rails.logger.info "ERROR #{books[:error]}"

      render json: { error: books[:error] }, status: :bad_request
    else
      Rails.logger.info "BOOKS #{books}"

      ActionCable.server.broadcast(
        "SearchChannel",
        { message: books }
      )

      render json: { message: "Search initiated successfully" }, status: :ok
    end
  end

  def update
    if @book.update!(book_params)
      render json: @book
    end
  end

  def destroy
    @book.destroy!
  end

  private

    def book_params
      params.require(:book).permit(:title, { authors: [] }, :published_date, :isbn, :page_count, :cover_image)
    end

    def set_book
      @book = Book.find(params.require(:id))
    end
end
