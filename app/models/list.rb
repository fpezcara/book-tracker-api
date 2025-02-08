# frozen_string_literal: true

class List < ApplicationRecord
  has_and_belongs_to_many :books
  belongs_to :user
  #  todo: create default lists for users (reading, to-read, completed)
  validates :name, presence: true
end
