require_relative "./providers_states_for_book_tracker.rb"

Pact.service_provider "Book_Tracker_API" do
  app { Rails.application }

  honours_pact_with "Book_Tracker_UI" do
    pact_uri ENV["PACT_URI"] || File.expand_path("../../../pact/pacts/book_tracker_ui-book_tracker_api.json", __FILE__)
  end
end
