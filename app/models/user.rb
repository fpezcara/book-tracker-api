# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :lists, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # todo: call in callback after_create :create_default_lists & add a method called def create_default_lists and call list.create_default_lists(self)
end
