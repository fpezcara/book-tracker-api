# frozen_string_literal: true

module Authentication
  extend ActiveSupport::Concern

  included do
    before_action :require_authentication
    helper_method :authenticated?
  end

  class_methods do
    def allow_unauthenticated_access(**options)
      skip_before_action :require_authentication, **options
    end
  end

  private

    def authenticated?
      current_user.present?
    end

    def require_authentication
      Rails.logger.info "CURRR user, #{current_user.present?}"
      head :unauthorized unless current_user
    end

    def current_user
      puts "Session data:", session.to_hash # Debug: Print session contents
      Rails.logger.debug "Current user: #{session[:user_id]}"

      return @current_user if defined?(@current_user)

      @current_user ||= session[:user_id] ? User.find_by(id: session[:user_id]) : nil
      @current_user
    end

    def log_in(user)
      reset_session

      session[:user_id] = user.id
      @current_user = user
      user.sessions.create!(user_agent: request.user_agent, ip_address: request.remote_ip)
    end

    def log_out
      return unless current_user

      current_user.sessions.delete_all

      @current_user = nil
      session[:user_id] = nil
      reset_session
    end

    def logged_in?
      !current_user.nil?
    end
end
