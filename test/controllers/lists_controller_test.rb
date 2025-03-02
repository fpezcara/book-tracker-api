require "test_helper"

class ListsControllerTest < ActionController::TestCase
  def setup
    @user = FactoryBot.create(:user)
    @session = Session.create(user: @user)
    cookies.signed[:session_id] = @session_id
    @list = FactoryBot.create(:list)
  end

  class IndexActionTest < ListsControllerTest
    test "GET /users/:user_id/lists when user is signed out, it returns unauthorised" do
      cookies.signed[:session_id] = nil

      get :index, params: { user_id: 1234 }

      assert_response :unauthorized
    end

    test "GET /users/:user_id/lists when user is signed in & and invalid user_id is passed, it returns unauthorised" do
      get :index, params: { user_id: 1234 }

      assert_response :unauthorized
    end


    test "GET /users/:user_id/lists when user is signed in & an valid user_id is passed, it returns an empty array if there are no lists" do
      get :index, params: { user_id: @user.id }
      puts @user.id.class
      assert_response :success
    end
  end
end
