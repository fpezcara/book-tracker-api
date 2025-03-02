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

      get :index, params: { user_id: @user.id }

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

  class CreateActionTest < ListsControllerTest
    test "POST /users/:user_id/lists when user is signed out, it returns unauthorized" do
      cookies.signed[:session_id] = nil

      post :create, params: { user_id: 1234 }

      assert_response :unauthorized
    end

    test "POST /users/:user_id/lists when user is signed in & invalid user_id is passed, it returns unauthorized" do
      post :create, params: { user_id: 1234, book: { name: "Wishlist" } }

      assert_response :unauthorized
    end

    test "POST /users/:user_id/lists when user is signed in & valid user_id is passed & name is not passed, it returns bad request" do
      post :create, params: { user_id: @user.id, list: {} }

      assert_response :bad_request
    end

    test "POST /users/:user_id/lists when user is signed in & valid user_id is passed & name is passed, it creates list" do
     list_name = "Thriller"

     post :create, params: { user_id: @user.id, list: { name: list_name } }

     assert_response :success
     assert_equal list_name, List.last[:name]
     assert_includes response.body, list_name.to_json
   end
  end

  class ShowActionTest < ListsControllerTest
    def setup
      super
      @list = FactoryBot.create(:list, user_id: @user.id)
    end

    test "GET /users/:user_id/lists/:id when user is signed out, it returns unauthorized" do
      cookies.signed[:session_id] = nil

      get :show, params: { user_id: @user.id, id: @list.id }

      assert_response :unauthorized
    end

    test "GET /users/:user_id/lists/:id when user is signed in & no list id is passed, it returns bad request" do
      get :show, params: { user_id: @user.id, id: "" }

      assert_response :bad_request
    end

    test "GET /users/:user_id/lists/:id when user is signed in & invalid list id is passed, it returns not found" do
      get :show, params: { user_id: @user.id, id: "invalid_id" }

      assert_response :not_found
    end

    test "GET /users/:user_id/lists/:id when user is signed in & valid list id is passed, it renders the list" do
      get :show, params: { user_id: @user.id, id: @list.id }

      assert_response :success
      assert_includes response.body, @list.to_json
    end
  end
end
