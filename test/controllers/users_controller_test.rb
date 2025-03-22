require "test_helper"

class UsersControllerTest < ActionController::TestCase
  def setup
    @user_params = { email_address: "random@email.com", password: "password1234", password_confirmation: "password1234" }
    @user = FactoryBot.create(:user)
  end

  class CreateActionTest < UsersControllerTest
    test "POST /users when no params are passed, it returns bad request" do
      post :create, params: { user: {} }

      assert_response :bad_request
    end

    test "POST /users when email_address is not passed, it returns bad request" do
      post :create, params: { user: { email_address: "", password: "password12345", password_confirmation: "password12345" } }

      assert_response :bad_request
    end

    test "POST /users when password is not passed, it returns bad request" do
      post :create, params: { user: { email_address: "fake_email@email.com", password: "", password_confirmation: "password12345" } }

      assert_response :bad_request
    end

    test "POST /users when password and password_confirmation don't match, it returns bad request" do
      @user_params[:password_confirmation] = "wrong_password"

      post :create, params: { user: @user_params }

      assert_response :bad_request
      assert_equal({ message: "Validation failed: Password confirmation doesn't match Password" }.to_json, response.body)
    end

    test "POST /users when valid params are passed, it creates a new user and logs the user in" do
      post :create, params: { user: @user_params }

      created_user = User.last

      assert_response :created
      assert_equal @user_params[:email_address], created_user.email_address
      assert BCrypt::Password.new(created_user.password_digest).is_password?(@user_params[:password])

      assert_equal created_user.id, session[:user_id]
    end
  end

  class ShowActionTest < UsersControllerTest
    test "GET /users/:id when user is not signed in, it returns unauthorized" do
      get :show, params: { id: @user.id }

      assert_response :unauthorized
    end

    test "GET /users/:id when user is signed in & an invalid user_id is passed, it returns unauthorized" do
      session[:user_id] = @user.id

      get :show, params: { id: 2312 }

      assert_response :unauthorized
    end

    test "GET /users/:id when user is signed in & a valid user_id is passed, it returns success" do
     session[:user_id] = @user.id

     get :show, params: { id: @user.id }

     assert_response :success
   end
  end

  class UpdateActionTest < UsersControllerTest
    test "PATCH /users/:id when user is logged out, it returns unauthorised" do
      patch :update, params: { id: @user.id, user: {} }

      assert_response :unauthorized
    end

    test "PATCH /users/:id when user is logged in & no params are passed, it returns bad request" do
      session[:user_id] = @user.id

      patch :update, params: { id: @user.id, user: { email_address: "" } }

      assert_response :bad_request
    end

    test "PATCH /users/:id when user is logged in & valid params are passed, it updates the user" do
      session[:user_id] = @user.id
      new_email = "new_email@email.com"
      new_password = "newpAssWord121"

      patch :update, params: { id: @user.id, user: { email_address: new_email, password: new_password, password_confirmation: new_password } }


      assert_response :success
      assert_equal new_email, @user.reload.email_address
      assert BCrypt::Password.new(@user.reload.password_digest).is_password?(new_password)

      expected_response = JSON.parse(@user.reload.to_json)
      actual_response = JSON.parse(response.body)
      assert_equal expected_response, actual_response
    end
  end

  class DestroyActionTest < UsersControllerTest
    test "DELETE /users/:id when user is logged out, it returns unauthorized" do
      delete :destroy, params: { id: @user.id }

      assert_response :unauthorized
    end

    test "DELETE /users/:id when user is logged in & invalid id is passed, it returns not found" do
      delete :destroy, params: { id: 1234 }

      assert_response :unauthorized
    end

    test "DELETE /users/:id when user is logged in & valid id is passed, it deletes the user & session" do
    session[:user_id] = @user.id

    delete :destroy, params: { id: @user.id }

    assert_response(204)
    assert_nil Current.session
    assert_nil User.find_by(id: @user.id)
  end
  end
end
