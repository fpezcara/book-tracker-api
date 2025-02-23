# frozen_string_literal: true

class Book < ApplicationRecord
  has_and_belongs_to_many :lists

  validates :title, presence: true
  validates :isbn, presence: true, uniqueness: true

  def as_json(options = {})
    super(options).merge("published_date" => published_date&.strftime("%Y-%m-%d"))
  end
end
