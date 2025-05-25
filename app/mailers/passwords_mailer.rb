# frozen_string_literal: true

class PasswordsMailer < ApplicationMailer
  def reset(user, token)
    @user = user
    @token = token

    mail subject: "Reset your password", to: user.email_address
  end
end
