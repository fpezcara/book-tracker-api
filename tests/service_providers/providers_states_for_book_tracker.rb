Pact.provider_states_for "Book_Tracker_UI" do
  provider_state "a user is registered" do
    set_up do
      User.create!(
        email: "fake@email.com",
        password: "fakePassword",
        password_confirmation: "fakePassword",
        id: 9
      )
    end

    # tear_down do
    #   # Clean up
    #   User.destroy_all
    # end
  end
end