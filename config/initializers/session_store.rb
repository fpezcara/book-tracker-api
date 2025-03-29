Rails.application.config.session_store :cookie_store,
  key: "_book_tracker_session",
  same_site: Rails.env.production? ? :none : :lax,
  secure: true,
  domain: Rails.env.production? ? "book-tracker-backend-lpy4.onrender.com" : :all,
  http_only: true,
  expire_after: 1.day
