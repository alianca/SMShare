class UserFileImageUploader < CarrierWave::Uploader::Base
  storage :grid_fs

  def extension_white_list
    %w(jpg jpeg gif png bmp)
  end

  def store_dir
    "user_file_image/#{model.id}"
  end
end
