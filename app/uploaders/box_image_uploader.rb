class BoxImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  
  storage :file
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
  process :resize_to_fill => [345, 165]
  
  version :thumb do
    process :resize_to_fill => [135, 60]
  end
  
  def store_dir
    "box_images/#{model.id}"
  end
  
end
