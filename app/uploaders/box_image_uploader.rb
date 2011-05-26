class BoxImageUploader < CarrierWave::Uploader::Base
  storage :grid_fs
  
  def store_dir
    "box_images/#{model.id}"
  end
end
