class ListsController < ApplicationController
  include Authentication

  before_action :require_authentication, only: %i[index create show update destroy]
  before_action :set_user, only: %i[index create show update destroy]
  before_action :set_list, only: %i[show update destroy]

  def index
    lists = List.where(user_id: params[:user_id])

    render json: lists.map(&:as_json_with_books)
  end

  def create
    list = current_user.lists.create!(list_params)

    if list.save!
      render json: list
    end
  end

  def show
    render json: @list
  end

  def update
    if @list.update!(list_params)
      render json: @list
    end
  end

  def destroy
    @list.destroy!
  end

  private

    def list_params
      params.require(:list).permit(:name).tap do |list_params|
        list_params[:user_id] = @user.id
      end
    end

    def set_list
      @list = List.find(params.require(:id))
    end

    def set_user
      @user = current_user if params[:user_id] == current_user&.id.to_s

      head :unauthorized and return unless @user
    end
end
