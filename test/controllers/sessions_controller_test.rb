require "test_helper"

class SessionsControllerTest < ActionController::TestCase
  def setup
    @user = FactoryBot.create(:user, email_address: "testing@email.com", password: "password")
  end

  class CreateActionTest < SessionsControllerTest
    test "POST /session when no params are passed, it returns unauthorized" do
      post :create, params: { email_address: nil, password: nil }

      assert_response :unauthorized
    end

    test "POST /session when invalid params are passed, it returns unauthorized" do
      post :create, params: { email_address: "invalid@email.com", password: "wrong_password" }

      assert_response :unauthorized
    end

    test "POST /session when valid params are passed, it returns logs user in" do
      post :create, params: { email_address: @user[:email_address], password: "password" }

      session = Session.find_by(user_id: @user.id)

      assert_response :success
      assert_equal session.id, cookies.signed[:session_id]
      assert_not_nil session, "Session was not created"
    end
  end

  class DestroyActionTest < SessionsControllerTest
    test "/DELETE logs users out" do
      session = Session.create!(user_id: @user.id)
      cookies.signed[:session_id] = session.id

      delete :destroy

      assert_response :success
    end
  end

  class CurrentUserActionTest < SessionsControllerTest
    test "/GET when user is logged out, it returns unauthorized" do
      get :current_user

      assert_response :unauthorized
    end

    test "/GET when user is logged in, it returns the user" do
      session = Session.create!(user_id: @user.id)
      cookies.signed[:session_id] = session.id

      get :current_user

      assert_response :success
    end
  end
end
