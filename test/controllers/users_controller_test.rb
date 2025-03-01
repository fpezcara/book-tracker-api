require "test_helper"

class UsersControllerTest < ActionController::TestCase
  def setup
    @user_params = { email_address: "random@email.com", password: "password1234", password_confirmation: "password1234" }
  end

  class CreateActionTest < UsersControllerTest
    test "POST /users when invalid params it returns bad request" do
      post :create, params: { user: {} }

      assert_response :bad_request
    end

    test "POST /users when password and password_confirmation don't match it returns bad request" do
     @user_params[:password_confirmation] = "wrong_password"

     post :create, params: { user: @user_params }

     assert_response :bad_request
     assert_equal response.body, { "message": "Validation failed: Password confirmation doesn't match Password" }.to_json
   end

    test "POST /users when valid params are passed it created new user" do
      post :create, params: { user: @user_params }

      assert_response :created
    end
  end
end
