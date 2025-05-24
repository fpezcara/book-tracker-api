# frozen_string_literal: true

class PasswordsController < ApplicationController
  allow_unauthenticated_access
  before_action :set_user_by_token, only: %i[ update ]

  def create
    if user_params[:email_address].blank?
      head :bad_request
      return
    end

    if user = User.find_by(email_address: user_params[:email_address])
      PasswordsMailer.reset(user).deliver_later
      render json: { message: "Password reset instructions sent (if user with that email address exists)." }, status: :ok
    else
      head :not_found
    end
  end

  def update
    if @user.update(password_params)
      redirect_to passwords_path, notice: "Password has been reset successfully."
    else
      redirect_to edit_password_path(params[:token]), alert: "Passwords did not match."
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
