require "test_helper"

class ListTest < ActiveSupport::TestCase
  setup do
    @book = FactoryBot.create(:book)
    @list = FactoryBot.create(:list)
  end

  test "valid list" do
    assert @list.valid?
  end

  test "should have many books" do
    assert_respond_to @list, :books
  end

  test "should add list to book" do
    @book.lists << @list

    assert_includes @book.lists, @list, "Book does not have the associated list"
  end

  test "should remove list from book" do
    @book.lists << @list
    @book.lists.delete(@list)

    assert_not_includes @book.lists, @list, "Book still has the associated list"
  end
end
