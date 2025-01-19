class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books, id: :uuid do |t|
      t.string :title
      t.string :authors, array: true
      t.datetime :published_date
      t.string :isbn
      t.integer :page_count
      t.string :cover_image

      t.timestamps
    end
  end
end
