class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :grid_fs

  def extension_white_list
    %w(jpg jpeg gif png bmp)
  end

  process :resize_to_fill => [90, 90]

  def store_dir
    "avatar/#{model.id}"
  end

  def default_url
    "/images/user_panel/default_avatar.png"
  end

end
