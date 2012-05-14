class Answer
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, :type => String

  embedded_in :comment, :inverse_of => :answers
  belongs_to_related :owner, :class_name => "User"
end
