class ChangeListIdTypeInBooksLists < ActiveRecord::Migration[8.0]
  def change
    remove_column :books_lists, :list_id, :bigint
    add_column :books_lists, :list_id, :uuid
  end
end
