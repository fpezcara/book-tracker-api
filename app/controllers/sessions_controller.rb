# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10,
             within: 3.minutes,
             only: :create

  # def new
  # end

  def create
    user = User.authenticate_by(create_params)

    if user
      start_new_session_for user
      head :ok
    else
      head :unauthorized
    end
  end

  def destroy
    terminate_session
  end

  def current_user
    if Current.user
      render json: { user: Current.user }
    else
      head :unauthorized
    end
  end

  private

    def create_params
      params.permit(:email_address, :password)
    end
end
