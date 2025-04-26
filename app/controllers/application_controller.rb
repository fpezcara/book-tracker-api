# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # before_action :debug_cookies
  # after_action :debug_cookies_after

  rescue_from ActionController::ParameterMissing,
             with: :rescue_from_parameter_missing

  rescue_from ActiveRecord::RecordNotFound, with: :rescue_from_not_found_status

  rescue_from ActiveRecord::RecordInvalid, with: :rescue_from_invalid_record

  private

    def rescue_from_parameter_missing(exception)
      render json: { message: exception.message }, status: :bad_request
    end

    def rescue_from_not_found_status(exception)
      render json: { message: exception.message }, status: :not_found
    end

    def rescue_from_invalid_record(exception)
      render json: { message: exception.message }, status: :bad_request
    end

    def debug_cookies
      puts "Cookies before action: #{cookies.to_hash}"
    end

    def debug_cookies_after
      puts "Cookies after action: #{cookies.to_hash}"
    end
end
