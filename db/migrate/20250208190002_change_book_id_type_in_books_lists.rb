class ChangeBookIdTypeInBooksLists < ActiveRecord::Migration[8.0]
  def change
    remove_column :books_lists, :book_id, :bigint
    add_column :books_lists, :book_id, :uuid, null: false
  end
end
