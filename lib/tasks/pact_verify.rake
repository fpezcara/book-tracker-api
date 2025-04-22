# Skip loading in production during asset precompilation
return if ENV["SECRET_KEY_BASE_DUMMY"]

# Only load Pact configuration in test/development environments
if Rails.env.test? || Rails.env.development?
  require "pact/tasks"

  Pact.service_provider "Book_Tracker_API" do
    app { Rails.application }

    honours_pact_with "Book_Tracker_UI" do
      pact_uri ENV["PACT_URI"] || File.expand_path("../../../pact/pacts/book_tracker_ui-book_tracker_api.json", __FILE__)
    end
  end
end
