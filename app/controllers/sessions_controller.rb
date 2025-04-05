# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token
  allow_unauthenticated_access only: %i[ create ]
  rate_limit to: 10,
             within: 3.minutes,
             only: :create

  def create
    user = User.authenticate_by(create_params)

    if user
      log_in(user)

      render json: { user_id: user.id }, status: :created
    else
      head :unauthorized
    end
  end

  def destroy
    if logged_in?
      log_out
      head :no_content
    else
      head :unauthorized
    end
  end

  private

    def create_params
      params.require(:session).permit(:email_address, :password)
    end
end
