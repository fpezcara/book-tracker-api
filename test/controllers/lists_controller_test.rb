require "test_helper"

class ListsControllerTest < ActionController::TestCase
  def setup
    @user = FactoryBot.create(:user)
  end

  class IndexActionTest < ListsControllerTest
    test "GET /users/:user_id/lists when user is signed out, it returns unauthorized" do
      get :index, params: { user_id: @user.id }

      assert_response :unauthorized
    end

    test "GET /users/:user_id/lists when user is signed in & and invalid user_id is passed, it returns unauthorized" do
      session[:user_id] = @user.id

      get :index, params: { user_id: 1234 }

      assert_response :unauthorized
    end

    test "GET /users/:user_id/lists when user is signed in & a valid user_id is passed, it returns the defaulted lists" do
      session[:user_id] = @user.id

      get :index, params: { user_id: @user.id }

      response_body = JSON.parse(response.body)
      list_names = response_body.map { |list| list["name"] }

      assert_response :success
      assert_includes list_names, "Reading"
      assert_includes list_names, "Wishlist"
      assert_includes list_names, "Finished"
      assert_equal 3, @user.lists.count
    end

    test "GET /users/:user_id/lists when user is signed in & a valid user_id is passed, it returns lists with books array" do
      session[:user_id] = @user.id
      list = FactoryBot.create(:list, user_id: @user.id)
      book = FactoryBot.create(:book)
      list.books << book

      get :index, params: { user_id: @user.id }

      response_body = JSON.parse(response.body)

      assert_response :success
      assert_includes response_body.map { |list| list["name"] }, list.name
      assert_equal response_body.find { |l| l["name"] == list.name }["books"].count, 1
    end
  end

  class CreateActionTest < ListsControllerTest
    test "POST /users/:user_id/lists when user is signed out, it returns unauthorized" do
      post :create, params: { user_id: 1234 }

      assert_response :unauthorized
    end

    test "POST /users/:user_id/lists when user is signed in & invalid user_id is passed, it returns unauthorized" do
      session[:user_id] = @user.id

      post :create, params: { user_id: 1234, book: { name: "Wishlist" } }

      assert_response :unauthorized
    end

    test "POST /users/:user_id/lists when user is signed in & valid user_id is passed & name is missing, it returns bad request" do
      session[:user_id] = @user.id

      post :create, params: { user_id: @user.id, name: nil }

      assert_response :bad_request
    end

    test "POST /users/:user_id/lists when user is signed in & valid user_id is passed & name is passed, it creates list" do
     session[:user_id] = @user.id
     list_name = "Thriller"

     post :create, params: { user_id: @user.id, list: { name: list_name } }

     assert_response :success
     assert_equal list_name, @user.lists.order(:created_at).last.name
     assert_includes response.body, list_name.to_json
     assert_equal 4, List.count
   end
  end

  class ShowActionTest < ListsControllerTest
    def setup
      super
      @list = FactoryBot.create(:list, user_id: @user.id)
    end

    test "GET /users/:user_id/lists/:id when user is signed out, it returns unauthorized" do
      get :show, params: { user_id: @user.id, id: @list.id }

      assert_response :unauthorized
    end

    test "GET /users/:user_id/lists/:id when user is signed in & no list id is passed, it returns bad request" do
      session[:user_id] = @user.id

      get :show, params: { user_id: @user.id, id: "" }

      assert_response :bad_request
    end

    test "GET /users/:user_id/lists/:id when user is signed in & invalid list id is passed, it returns not found" do
      session[:user_id] = @user.id

      get :show, params: { user_id: @user.id, id: "invalid_id" }

      assert_response :not_found
    end

    test "GET /users/:user_id/lists/:id when user is signed in & valid list id is passed, it renders the list" do
      session[:user_id] = @user.id

      get :show, params: { user_id: @user.id, id: @list.id }

      assert_response :success
      assert_includes response.body, @list.to_json
    end
  end

  class UpdateActionTest < ListsControllerTest
    def setup
      super
      @list = FactoryBot.create(:list, user_id: @user.id)
    end

    test "PATCH /users/:user_id/lists/:id when user is signed out, it returns unauthorized" do
      patch :update, params: { user_id: @user.id, id: @list.id }

      assert_response :unauthorized
    end

    test "PATCH /users/:user_id/lists/:id when user is signed in & no id is passed, it returns bad request" do
      session[:user_id] = @user.id

      patch :update, params: { user_id: @user.id, id: "" }

      assert_response :bad_request
    end

    test "PATCH /users/:user_id/lists/:id when user is signed in & invalid id is passed, it returns not found" do
     session[:user_id] = @user.id

     patch :update, params: { user_id: @user.id, id: "invalid_id" }

     assert_response :not_found
   end

    test "PATCH /users/:user_id/lists/:id when user is signed in & valid id is passed & name to update is missing, it returns bad request" do
     session[:user_id] = @user.id

     patch :update, params: { user_id: @user.id, id: @list.id }

     assert_response :bad_request
   end
    test "PATCH /users/:user_id/lists/:id when user is signed in & valid id is passed, it updates the list record" do
      session[:user_id] = @user.id
      new_name = "Completed"

      patch :update, params: { user_id: @user.id, id: @list.id, list: { name: new_name } }

      assert_response :success
      assert_equal new_name, @list.reload.name
      assert_includes response.body, new_name.to_json
    end
  end

  class DestroyActionTest < ListsControllerTest
    def setup
      super
      @list = FactoryBot.create(:list, user_id: @user.id)
    end

    test "DELETE /users/:user_id/lists/:id when user is signed out, it returns unauthorised" do
      delete :destroy, params: { user_id: @user.id, id: @list.id }

      assert_response :unauthorized
    end

    test "DELETE /users/:user_id/lists/:id when user is signed in & list id is missing, it returns bad request" do
      session[:user_id] = @user.id

      delete :destroy, params: { user_id: @user.id, id: "" }

      assert_response :bad_request
    end

    test "DELETE /users/:user_id/lists/:id when user is signed in & list id is valid, it deletes the list record" do
      session[:user_id] = @user.id

      delete :destroy, params: { user_id: @user.id, id: @list.id }

      assert_response(204)
      # only have the 3 defaulted lists left
      assert_equal 3, List.count
      assert_nil List.find_by(id: @list.id)
    end
  end

  class AddBookActionTest < ListsControllerTest
    def setup
      super
      @list = FactoryBot.create(:list, user_id: @user.id)
      @book_params = { title: "Dracula", authors: [ "Bram Stoker" ], published_date: Faker::Date.backward(days: 365), isbn: "9781503261389", page_count: 260 }
    end

    test "POST /users/:user_id/lists/:list_id/add_book when user is logged out, it returns unauthorized" do
      post :add_book, params: { user_id: @user.id, id: @list.id, book: @book_params }

      assert_response :unauthorized
    end

    test "POST /users/:user_id/lists/:list_id/add_book when user is logged in and invalid user id is passed, it returns unauthorized" do
      session[:user_id] = @user.id

      post :add_book, params: { user_id: "invalid_id", id: @list.id, book: @book_params }

      assert_response :unauthorized
    end

    test "POST /users/:user_id/lists/:list_id/add_book when user is logged in and book param is missing, it returns bad request" do
      session[:user_id] = @user.id

      post :add_book, params: { user_id: @user.id, id: @list.id }

      assert_response :bad_request
    end

    test "POST /users/:user_id/lists/:list_id/add_book when user is logged in and valid book param passed is invalid, it returns bad request" do
      session[:user_id] = @user.id
      @book_params[:title] = nil

      post :add_book, params: { user_id: @user.id, id: @list.id, book: @book_params }

      assert_response :bad_request
      assert_equal @list.books, []
    end

    test "POST /users/:user_id/lists/:list_id/add_book when user is logged in and valid book param is passed, it adds the book to the list" do
      session[:user_id] = @user.id

      post :add_book, params: { user_id: @user.id, id: @list.id, book: @book_params }

      added_book = @list.books.last

      assert_response :success
      assert_not_nil added_book
      assert_equal @book_params[:title], added_book.title
      assert_equal @book_params[:authors], added_book.authors
      assert_equal @book_params[:isbn], added_book.isbn
    end
  end
end
