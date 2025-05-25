# frozen_string_literal: true

class PasswordsController < ApplicationController
  allow_unauthenticated_access
  skip_before_action :verify_authenticity_token, only: [ :create, :update ]
  before_action :set_user_by_token, only: %i[ update ]

  def create
    if user_params[:email_address].blank?
      head :bad_request
      return
    end

    if user = User.find_by(email_address: user_params[:email_address])
      @token = user.generate_token_for(:password_reset)
      PasswordsMailer.reset(user, @token).deliver_later

      render json: { message: "Password reset instructions sent (if user with that email address exists). Check your inbox" }, status: :ok
    else
      head :not_found
    end
  end

  def update
    if @user.update(password_params)
      render json: { message: "Password has been successfully updated. Please login." }, status: :ok
    else
      render json: { error: "There has been an error processing your request. Please try again" }, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.require(:user).permit(:email_address)
    end

    def password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def set_user_by_token
      @user = User.find_by_password_reset_token!(params[:token])
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      render json: { error: "Password reset link is invalid or has expired." }, status: :unprocessable_entity
    end
end
