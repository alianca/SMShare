class Avatar
  include Mongoid::Document
  
  mount_uploader :avatar, AvatarUploader, :mount_on => :filename
  
  embedded_in :user_profile, :inverse_of => :avatar
  
end

