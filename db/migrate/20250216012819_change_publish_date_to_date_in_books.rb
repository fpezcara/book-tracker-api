class ChangePublishDateToDateInBooks < ActiveRecord::Migration[8.0]
  def change
    change_column :books, :published_date, :date
  end
end
