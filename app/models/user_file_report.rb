class UserFileReport
  include Mongoid::Document
  include Mongoid::Timestamps
  
  embedded_in :file, :class_name => "UserFile", :inverse_of => :reports
  referenced_in :reporter, :class_name => "User"
end
