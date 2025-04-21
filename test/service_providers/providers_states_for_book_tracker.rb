Pact.provider_states_for "Book_Tracker_UI" do
  provider_state "a user exists" do
    set_up do
      puts "=== Setting up provider state: a user exists ==="
      user = FactoryBot.create(:user, email_address: "user@exists.com")
      puts "Created user: #{user.inspect}"
    end

    provider_state "a user does not exist" do
      puts "=== Setting up provider state: a user does not exist ==="
      end
  end
end
