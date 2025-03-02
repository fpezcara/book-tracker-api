require "test_helper"

class ListsControllerTest < ActionController::TestCase
  def setup
    @user = FactoryBot.create(:user)
    @session = Session.create(user: @user)
    cookies.signed[:session_id] = @session.id
  end

  class IndexActionTest < ListsControllerTest
    test "GET /users/:user_id/lists when user is signed out, it returns unauthorized" do
      cookies.signed[:session_id] = nil

      get :index, params: { user_id: 1234 }

      assert_response :unauthorized
    end

    test "GET /users/:user_id/lists when user is signed in & and invalid user_id is passed, it returns unauthorized" do
      get :index, params: { user_id: 1234 }

      assert_response :unauthorized
    end


    test "GET /users/:user_id/lists when user is signed in & a valid user_id is passed, it returns an empty array if there are no lists" do
      get :index, params: { user_id: @user.id }

      assert_response :success
      assert_equal([].to_json, response.body)
    end

    test "GET /users/:user_id/lists when user is signed in & a valid user_id is passed, it returns lists if they exists" do
      list = FactoryBot.create(:list, user_id: @user.id)

      get :index, params: { user_id: @user.id }

      assert_response :success
      assert_includes response.body, list.to_json
    end
  end
end
