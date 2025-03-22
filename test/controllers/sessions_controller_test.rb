require "test_helper"

class SessionsControllerTest < ActionController::TestCase
  def setup
    @user = FactoryBot.create(:user, email_address: "testing@email.com", password: "password")
  end

  class CreateActionTest < SessionsControllerTest
    test "POST /session when no params are passed, it returns bad request" do
      post :create, params: { session: {} }

      assert_response :bad_request
    end

    test "POST /session when invalid params are passed, it returns unauthorized" do
      post :create, params: { session: { email_address: "invalid@email.com", password: "wrong_password" } }

      assert_response :unauthorized
    end

    test "POST /session when valid params are passed, it logs user in" do
      post :create, params: { session: { email_address: @user[:email_address], password: "password" } }

      assert_response :success
      assert_equal @user.id, session[:user_id]
      assert_not_nil session, "Session was not created"
    end
  end

  class DestroyActionTest < SessionsControllerTest
    test "/DELETE logs users out" do
      session[:user_id] = @user.id

      delete :destroy
      assert_nil session[:user_id]
      assert_response :success
    end
  end
end
