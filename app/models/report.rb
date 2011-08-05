class Report
  include Mongoid::Document
  include Mongoid::Timestamps
  
  belongs_to_related :file, :class_name => 'UserFile'
  belongs_to_related :owner, :class_name => 'User'
  
end

