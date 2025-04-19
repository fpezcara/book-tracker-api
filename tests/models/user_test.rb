require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.build(:user)
  end

  test "valid user" do
    assert @user.valid?
    assert_difference "User.count", +1 do
      @user.save!
    end
  end

  test "creates default lists when user is valid" do
    @user.save!

    assert_equal 3, @user.lists.count
    assert_equal "Reading", @user.lists[0].name
    assert_equal "Wishlist", @user.lists[1].name
    assert_equal "Finished", @user.lists[2].name
  end

  test "invalid when email_address is missing" do
    @user.email_address = nil
    # trigger validation
    @user.valid?

    assert_not @user.valid?
    assert_equal [ "Email address can't be blank" ], @user.errors.full_messages
  end

  test "invalid when password is missing" do
    @user.password = nil
    @user.valid?

    assert_not @user.valid?
    assert_equal [ "Password can't be blank" ], @user.errors.full_messages
  end

  test "invalid when password and password_confirmation do not match" do
    @user.password = "password1234"
    @user.password_confirmation = "password12345"
    @user.valid?

    assert_not @user.valid?
    assert_equal [ "Password confirmation doesn't match Password" ], @user.errors.full_messages
  end

  test "user can have many lists" do
    list1 = FactoryBot.create(:list, user: @user)
    list2 = FactoryBot.create(:list, name: "wishlist", user: @user)

    assert_equal 5, @user.lists.count
    assert_includes @user.lists, list1
    assert_includes @user.lists, list2
  end

  test "destroying user also destroys associated lists" do
    FactoryBot.create(:list, user: @user)

    assert_difference "List.count", -4 do
      @user.destroy
    end
  end
end
