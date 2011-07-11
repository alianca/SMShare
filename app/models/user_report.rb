class UserReport
  include Mongoid::Document
  include Mongoid::Timestamps
  
  embedded_in :user, :inverse_of => :reports
  referenced_in :reporter, :class_name => "User"
end
