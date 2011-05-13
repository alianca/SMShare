class ImageUploader < CarrierWave::Uploader::Base
  storage :grid_fs
  
  def store_dir
    "images/#{model.id}"
  end
end
