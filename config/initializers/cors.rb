Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "http://localhost:3000", "http://book-tracker-alpha.vercel.app"
    resource "*", headers: :any, methods: [ :get, :post, :put, :patch, :delete, :options, :head ]
  end
end
