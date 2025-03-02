class ListsController < ApplicationController
  include Authentication

  before_action :require_authentication, only: %i[index create show update destroy]
  before_action :set_user, only: %i[index create show update destroy]
  before_action :set_list, only: %i[show update destroy]

  def index
    lists = List.where(user_id: params[:user_id])

    render json: lists
  end

  def create
    list = List.create!(list_params)

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
      user_id = params[:user_id]
      @user = User.find_by(id: user_id) if user_id == Current.session&.user_id.to_s

      unless @user
        head :unauthorized and return
      end
    end
end
