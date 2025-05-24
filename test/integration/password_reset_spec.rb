require "test_helper"

# This is a request spec that tests the password reset flow via HTTP endpoints.
class PasswordResetRequestTest < ActionDispatch::IntegrationTest
  include FactoryBot::Syntax::Methods

  test "User can reset password" do
    user = create(:user, password: "old_password", password_confirmation: "old_password")

    # Step 1: Request password reset
    post passwords_path, params: { user: { email_address: user.email_address } }
    assert_response :ok
    assert_includes response.body, "Password reset instructions sent"

    # Reload user to get the updated password_reset_token
    user.reload

    # Step 2: Simulate clicking the reset link (assuming the token is valid)
    token = user.password_reset_token
    patch password_path(token), params: { user: { password: "new_password", password_confirmation: "new_password" } }

    # Step 3: Verify that the password was updated
    assert_response :redirect
    follow_redirect!
    user.reload
    assert user.authenticate("new_password")
  end
end
