# frozen_string_literal: true

class UsersController < ApplicationController
  include Authentication

  skip_before_action :verify_authenticity_token
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
      @user = User.find_by(id: params[:id]) if params[:id] == Current.session&.user_id.to_s

      unless @user
        head :unauthorized and return
      end
    end
end
