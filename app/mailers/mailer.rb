class Mailer < ActionMailer::Base
  default :from => "no-reply@smshare.com.br"

  def welcome_email(user)
    @user = user
    mail(:to => user.email, :subject => "Welcome to SMShare!")
  end
end
