# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :lists, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  after_create :create_default_lists

 private
   def create_default_lists
     lists.create!(name: "Reading")
     lists.create!(name: "Wishlist")
     lists.create!(name: "Finished")
   end
end
