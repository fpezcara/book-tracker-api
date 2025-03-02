class ListsController < ApplicationController
  include Authentication

  before_action :require_authentication, only: %i[index create show update destroy]
  before_action :set_user, only: %i[index create show update destroy]

  def index
    lists = List.where(user_id: params[:user_id])

    render json: lists
  end

  def create
    List.create(list_params)
  end

  def show
    # add code
  end

  def update
    # add code
  end

  def destroy
    # add code
  end

  private

    def list_params
      params.require(:list).permit(:name)
    end

    def list
      @list || List.find(id: params.require(:list)[:id])
    end

    def set_user
      user_id = params[:user_id]
      @user = User.find_by(id: user_id) if user_id == Current.session&.user_id.to_s

      unless @user
        head :unauthorized and return
      end
    end
end
