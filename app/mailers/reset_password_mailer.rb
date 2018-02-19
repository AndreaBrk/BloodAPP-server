class ResetPasswordMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reset_password_mailer.reset_password.subject
  #
  def reset_password(user)
    @user = user
    @new_password = SecureRandom.hex(10)
    mail to: user.email, subject: "Password has ben restablished"
  end
end
