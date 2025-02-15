require "test_helper"

class ListTest < ActiveSupport::TestCase
  setup do
    @book = FactoryBot.create(:book)
    @list = FactoryBot.create(:list)
  end

  test "valid list" do
    assert @list.valid?
  end

  test "invalid without a name" do
    @list.name = nil

    assert_not @list.valid?, "Saved the list without a name"
    assert_not_nil @list.errors[:name], "No validation error for title present"
  end

  test "should have many books" do
    assert_respond_to @list, :books
  end

  test "should add book to list" do
    @list.books << @book

    assert_includes @list.books, @book, "List does not have the associated book"
  end

  test "should remove book from list" do
    @list.books << @book
    @list.books.delete(@book)

    assert_not_includes @list.books, @book, "List still has the associated book"
  end
end
