require "test_helper"

class BookTest < ActiveSupport::TestCase
  setup do
    @book = FactoryBot.create(:book)
  end

  test "valid book" do
    assert @book.valid?
  end

  test "invalid without a title" do
    @book.title = nil

    assert_not @book.valid?, "Saved the book without a title"
    assert_not_nil @book.errors[:title], "No validation error for title present"
  end

  test "invalid with duplicate isbn" do
    @book.save!
    duplicate_book = FactoryBot.build(:book, isbn: @book.isbn)

    assert_not duplicate_book.valid?, "Saved the book with duplicate ISBN"
    assert_not_nil duplicate_book.errors[:isbn], "No validation error for ISBN present"
  end

  test "invalid with incorrect isbn length" do
    @book.isbn = "123"

    assert_not @book.valid?, "Saved the book with incorrect ISBN length"
    assert_not_nil @book.errors[:isbn], "No validation error for ISBN length present"
  end

  test "associations" do
    assert_respond_to @book, :lists
  end
end
