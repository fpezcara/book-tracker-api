require "test_helper"

class UsersControllerTest < ActionController::TestCase
  def setup
    @user_params = { email_address: "random@email.com", password: "password1234", password_confirmation: "password1234" }
    @user = FactoryBot.create(:user)
  end

  class CreateActionTest < UsersControllerTest
    test "POST /users when no params are passed it returns bad request" do
      post :create, params: { user: {} }

      assert_response :bad_request
    end

    test "POST /users when email_address is not passed it returns bad request" do
      post :create, params: { user: { email_address: "", password: "password12345", password_confirmation: "password12345" } }

      assert_response :bad_request
    end

    test "POST /users when password is not passed it returns bad request" do
      post :create, params: { user: { email_address: "fake_email@email.com", password: "", password_confirmation: "password12345" } }

      assert_response :bad_request
    end

    test "POST /users when password and password_confirmation don't match it returns bad request" do
      @user_params[:password_confirmation] = "wrong_password"

      post :create, params: { user: @user_params }

      assert_response :bad_request
      assert_equal response.body, { "message": "Validation failed: Password confirmation doesn't match Password" }.to_json
    end

    test "POST /users when valid params are passed it creates a new user and logs the user in" do
      post :create, params: { user: @user_params }
      created_user = User.last

      assert_response :created
      assert_equal created_user.email_address, @user_params[:email_address]
      assert_equal (BCrypt::Password.new(created_user.password_digest)), @user_params[:password]

      assert_not_nil cookies[:session_id]
    end
  end

  class ShowActionTest < UsersControllerTest
    test "GET /users/:id when user is not signed in it returns unauthorized" do
      get :show, params: { id: @user.id }

      assert_response :unauthorized
    end
  end
end
