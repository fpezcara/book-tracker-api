# Rakefile
require 'pact/tasks'

namespace :pact do
  desc "Verify provider against stored pacts"
  task :verify do
    # Default local path - override with PACT_URI env var in CI
    pact_uri = ENV.fetch('PACT_URI') do
      # Point to your consumer's pact file (adjust path as needed)
      Rails.root.join('../../book-tracker-ui/pact/pacts/book_tracker_ui-book_tracker_api.json').to_s
    end

    # For publishing verification results to broker (optional)
    ENV['PUBLISH_VERIFICATION_RESULTS'] = 'true' if ENV['CI']
    ENV['PROVIDER_VERSION'] = ENV['GIT_SHA'] if ENV['CI']

    Rake::Task['pact:verify:local'].invoke(pact_uri)
  end
end
