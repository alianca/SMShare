class PreSignup
  include Mongoid::Document

  EMAIL_REGEX = /^[\w\.%\+\-]+@[\w\-]+\.[\w\-\.]+$/i

  field :email, :type => String

  validates :email, {
    :presence => true,
    :format => { :with => EMAIL_REGEX }
  }

end
