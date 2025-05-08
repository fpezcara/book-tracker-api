class ListsController < ApplicationController
  include Authentication

  skip_before_action :verify_authenticity_token

  before_action :require_authentication, only: %i[index create show update destroy add_book remove_book]
  before_action :set_user, only: %i[index create show update destroy add_book remove_book]
  before_action :set_list, only: %i[show update destroy add_book remove_book]

  def index
    lists = List.where(user_id: params[:user_id])

    render json: lists.map(&:as_json_with_books)
  end

  def create
    list = current_user.lists.create!(list_params)

    if list.save!
      render json: list
    end
  end

  def show
    render json: @list
  end

  def update
    if @list.update!(list_params)
      render json: @list
    end
  end

  def destroy
    @list.destroy!
  end

  def add_book
    book = Book.find_or_create_by!(title: book_params[:title], isbn: book_params[:isbn], published_date: book_params[:published_date], page_count: book_params[:page_count], cover_image: book_params[:cover_image], authors: book_params[:authors])

    if @list.books.exists?(book.id)
      render json: { error: "Book is already in the list" }, status: :unprocessable_entity
    else
      @list.books << book
      render json: @list.as_json_with_books, status: :ok
    end
  end

  def remove_book
    book = Book.find(params[:book_id])

    @list.books.delete(book)
  end

  private

    def list_params
      params.require(:list).permit(:name).tap do |list_params|
        list_params[:user_id] = @user.id
      end
    end

    def book_params
      params.require(:book).permit(:title, :isbn, :published_date, :page_count, :cover_image, authors: [])
    end

    def set_list
      @list = List.find(params.require(:id))
    end

    def set_user
      @user = current_user if params[:user_id] == current_user&.id.to_s

      head :unauthorized and return unless @user
    end
end
