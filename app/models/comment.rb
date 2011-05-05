class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :message, :type => String
  field :rate, :type => Integer
  
  belongs_to_related :file, :class_name => "UserFile"
  belongs_to_related :owner, :class_name => "User"
  
end
