Pact.provider_states_for "Book_Tracker_UI" do
  provider_state "a user exists" do
    set_up do
      User.where(email_address: "user@exists.com").destroy_all
      user = FactoryBot.create(:user, email_address: "user@exists.com")
    end
  end

  provider_state "a user does not exist" do
    set_up do
      User.where(email_address: "fake@email.com").destroy_all
    end
  end
end
