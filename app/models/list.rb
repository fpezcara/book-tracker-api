# frozen_string_literal: true

class List < ApplicationRecord
  has_and_belongs_to_many :books
end
