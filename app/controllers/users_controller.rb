# frozen_string_literal: true

class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token
  include Authentication
  # add create and destroy fn to allow users to get created and deleted
  before_action :set_user, only: %i[show destroy update]

  def create
    user = User.create(create_params)

    if user.save!
      render json: user, status: :created
      start_new_session_for user
    end
  end

  def show
    render json: @user
  end

  def update
    @user.update!(create_params)

    render json: @user
  end

  def destroy
    @user.delete!
  end

  private

    def create_params
      params.require(:user).permit(:email_address, :password, :password_confirmation)
    end

    def set_user
      @user = User.find_by(id: params[:id]) if params[:id].to_i == @current_user&.id
      return unless @user.nil?

      head :unauthorized
    end
end
