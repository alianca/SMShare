# Use this hook to configure devise mailer, warden hooks and so forth. The first
# four configuration values can also be set straight in your models.
Devise.setup do |config|
  # ==> Mailer Configuration
  # Configure the e-mail address which will be shown in DeviseMailer.
  config.mailer_sender = "smshare@smshare.com.br"

  # Configure the class responsible to send e-mails.
  # config.mailer = "Devise::Mailer"

  # ==> ORM configuration
  # Load and configure the ORM. Supports :active_record (default) and
  # :mongoid (bson_ext recommended) by default. Other ORMs may be
  # available as additional gems.
  require 'devise/orm/mongoid'

  # ==> Configuration for :database_authenticatable
  # For bcrypt, this is the cost for hashing the password and defaults to 10. If
  # using other encryptors, it sets how many times you want the password re-encrypted.
  config.stretches = 10

  # Setup a pepper to generate the encrypted password.
  config.pepper = "13cd61689198c80456c223ca707ec39f665e14f783455bfb8fa86856da98e7f50967f0916f3c4b01f9e8bfe83c9a4c0df037420544f5866c4c8367eb6111bcdf"

  config.password_length = 5..42

  config.case_insensitive_keys = [:email]

  config.reset_password_within = 6.hours

end
