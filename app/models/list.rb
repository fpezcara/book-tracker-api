# frozen_string_literal: true

class List < ApplicationRecord
  has_and_belongs_to_many :books
  belongs_to :user
  #  todo: create default lists for users (reading, to-read, completed) => hacerlo en el users model
  # def self.create_default_lists(user) - is the user param needed?
  validates :name, presence: true, uniqueness: true
  before_save :capitalize_name

  def capitalize_name
   self.name = name&.capitalize
  end
end
