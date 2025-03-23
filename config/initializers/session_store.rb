Rails.application.config.session_store :cookie_store,
  key: "_book_tracker_session",
  same_site: Rails.env.production? ? :none : :lax,  # Use :none in production, :lax in development
  secure: Rails.env.production?,  # Set cookies as secure only in production
  domain: Rails.env.production? ? "book-tracker-alpha.vercel.app" : :all,  # Use production domain in production and :all for development
  http_only: true,
  expire_after: 1.day
