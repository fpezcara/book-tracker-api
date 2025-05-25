# Preview all emails at http://localhost:3001/rails/mailers/passwords_mailer
class PasswordsMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3001/rails/mailers/passwords_mailer/reset
  def reset
    user = User.take
    # Ensure the user has a password reset token for preview purposes
    user.generate_password_reset_token! if user && user.password_reset_token.blank?
    # In your mailer view, use:
    # reset_url = "http://localhost:3000/reset-password?token=#{@token}"
    PasswordsMailer.reset(user)
  end
end
