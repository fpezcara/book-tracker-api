require "test_helper"

class PasswordsMailerTest < ActionMailer::TestCase
  test "reset email is sent" do
    token = "test_token"
    user = FactoryBot.create(:user)
    email = PasswordsMailer.reset(user, token)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ user.email_address ], email.to
    assert_equal [ "from@example.com" ], email.from
    assert_match "Reset your password", email.subject
    # assert_match "Click here to reset your password", email.body.encoded
  end
end
