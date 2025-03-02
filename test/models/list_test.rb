require "test_helper"

class ListTest < ActiveSupport::TestCase
  setup do
    @book = FactoryBot.create(:book)
    @list = FactoryBot.create(:list, name: "wishlist")
  end

  test "valid list" do
    assert @list.valid?
  end

  test "invalid without a name" do
    @list.name = nil
    @list.valid?

    assert_not @list.valid?
    assert_equal [ "Name can't be blank" ], @list.errors.full_messages
  end

  test "name must be unique" do
    duplicated_list = FactoryBot.build(:list, name: @list.name)
    duplicated_list .valid?

    assert_not duplicated_list.valid?, "Saved the list with duplicate name"
    assert_equal [ "Name has already been taken" ], duplicated_list.errors.full_messages
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

  test "should capitalize book name" do
    list = FactoryBot.create(:list, name: "completed")

    assert_equal "Completed", list.reload.name
  end
end
