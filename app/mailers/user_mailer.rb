class UserMailer < ActionMailer::Base
  default :from => "notifications@music.com"

  def welcome_email(user, url)
    @user = user
    @url  = url
    mail(:to => user.email, :subject => "Welcome to Music")
  end

  def forgot_password_email(user, url)
    @user = user
    @url  = url
    mail(:to => user.email, :subject => "Forgot Password")
  end
end
