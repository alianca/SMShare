class UserFileImage
  include Mongoid::Document

  mount_uploader :image, UserFileImageUploader, :mount_on => :filename

  embedded_in :file, :class_name => "UserFile", :inverse_of => :images
end
