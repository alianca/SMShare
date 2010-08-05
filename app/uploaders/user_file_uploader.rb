# encoding: utf-8

class UserFileUploader < CarrierWave::Uploader::Base
  storage :grid_fs

  def store_dir
    "user_files/#{model.id}"
  end
end
