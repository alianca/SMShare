class BoxImageUploader < CarrierWave::Uploader::Base
  storage :file
  
  def store_dir
    "box_images/#{model.id}"
  end
end
