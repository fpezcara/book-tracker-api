ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../../config/environment", __dir__)
require "factory_bot"
require_relative "providers_states_for_book_tracker"

Pact.service_provider "Book_Tracker_API" do
  app { Rails.application }

  honours_pact_with "Book_Tracker_UI" do
    pact_uri ENV["PACT_URI"] || "pact/Book_Tracker_UI-Book_Tracker_API.json"
  end
end
