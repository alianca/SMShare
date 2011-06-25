class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  
  storage :file
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  process :resize_to_fill => [90, 90]
  
  def store_dir
    "box_images/#{model.id}"
  end
  
end
