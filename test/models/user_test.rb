require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user)
  end

  test "valid user" do
    assert @user.valid?
    assert_equal 1, User.count
  end

  test "invalid when email_address is missing" do
    @user.email_address = nil
    # trigger validation
    @user.valid?

    assert_not @user.valid?
    assert_equal ["Email address can't be blank"], @user.errors.full_messages
  end

  test "invalid when password is missing" do
    @user.password = nil
    @user.valid?

    assert_not @user.valid?
    assert_equal ["Password can't be blank"], @user.errors.full_messages
  end
end
