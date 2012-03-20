class UserFileImage
  include Mongoid::Document

  mount_uploader :user_file_image, UserFileImageUploader, :mount_on => :filename

  belongs_to_related :file, :class_name => "UserFile"

end
