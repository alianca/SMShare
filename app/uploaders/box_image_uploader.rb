class BoxImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :grid_fs

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  process :resize_to_fill => [345, 165]

  def store_dir
    "box_image/#{model.id}"
  end

end
