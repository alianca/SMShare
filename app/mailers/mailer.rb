class Mailer < ActionMailer::Base
  default :from => "no-reply@smshare.com.br"

  def welcome_email
    User.each do |user|
      mail {
        :to      => user.email,
        :subject => "Welcome to SMShare!"
      }
    end
  end
end
