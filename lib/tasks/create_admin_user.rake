namespace :admin do
  desc "Create an admin user"
  task create: :environment do
    User.create!(
      email: "fpezcara@gmail.com",
      password: "moritaPebbles",
      password_confirmation: "moritaPebbles",
      admin: true
    )
    puts "Admin user created with email: admin@example.com"
  end
end
