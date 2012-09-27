class Mailer < ActionMailer::Base
  default :from => "no-reply@smshare.com.br"

  def welcome_email
    emails = (User.all.to_a+PreSignup.all.to_a).map(&:email).uniq
    mail(:bcc => emails, :subject => "[smShare] Cadastros liberados!")
  end
end
