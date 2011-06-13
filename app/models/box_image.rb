class BoxImage
  include Mongoid::Document
  
  field :name, :type => String
  
  mount_uploader :image, BoxImageUploader, :mount_on => :filename
  
  belongs_to_related :user, :class_name => "User"
    
end
