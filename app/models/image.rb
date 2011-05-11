class Image
  include Mongoid::Document
  
  mount_uploader :image, ImageUploader, :mount_on => :filename
  
  belongs_to_related :file, :class_name => "UserFile"
  
end
