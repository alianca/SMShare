class UserFileImageUploader < CarrierWave::Uploader::Base
  storage :grid_fs

  def store_dir
    "user_file_image/#{model.id}"
  end
end
