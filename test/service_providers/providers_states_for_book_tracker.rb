Pact.provider_states_for "Book_Tracker_UI" do
  provider_state "a user exists" do
    set_up do
      User.where(email_address: "user@exists.com").destroy_all
      user = FactoryBot.create(:user, email_address: "user@exists.com", password: "fakePassword")
    end
  end

  provider_state "a user does not exist" do
    set_up do
      User.where(email_address: "fake@email.com").destroy_all
    end
  end

  provider_state "a user is logged in" do
    set_up do
      User.destroy_all
      List.destroy_all
      Book.destroy_all

      user_id = "100"
      list_id = "6e2875b7-dcec-4e63-b586-6dc071aba2c6"
      user = FactoryBot.create(:user, id: user_id)
      list = FactoryBot.create(:list, id: list_id, user_id: user_id)
      # to allow user to be authenticated
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end
  end
end
