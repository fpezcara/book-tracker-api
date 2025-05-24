require "test_helper"

class PasswordsControllerTest < ActionController::TestCase
  def setup
    @user = FactoryBot.create(:user)
  end

  class CreateActionTest < PasswordsControllerTest
    test "POST /passwords when no params are passed, it returns bad request" do
      post :create, params: {}

      assert_response :bad_request
    end

    test "POST /passwords when email_address is not passed, it returns bad_request" do
      post :create, params: { user: { email_address: "" } }

      assert_response :bad_request
    end

    test "POST /passwords when email_address is not valid, it returns not found" do
      post :create, params: { user: { email_address: "invalid_email@email.com" } }

      assert_response :not_found
    end

    test "POST /passwords when email_address is valid, it sends an email" do
    post :create, params: { user: { email_address: @user.email_address } }

    assert_response :success
  end
  end
end
