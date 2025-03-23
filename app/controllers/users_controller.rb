# frozen_string_literal: true

class UsersController < ApplicationController
  include Authentication

  skip_before_action :verify_authenticity_token
  before_action :set_user, only: %i[show update destroy]
  before_action :require_authentication, only: %i[ show update destroy]

  def create
    user = User.create(create_params)

    if user.save!
      log_in(user)

      render json: user, status: :created
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
    @user.destroy!

    log_out
  end

  private

    def create_params
      params.require(:user).permit(:email_address, :password, :password_confirmation)
    end

    def set_user
      @user = current_user if params[:id] == current_user&.id.to_s

      head :unauthorized and return unless @user
    end
end
