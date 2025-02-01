# frozen_string_literal: true

class Book < ApplicationRecord
  has_and_belongs_to_many :lists

  validates :title, presence: true
  validates :isbn, uniqueness: true, length: { is: 14 }
end
