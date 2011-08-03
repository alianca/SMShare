class BoxImage
  include Mongoid::Document
  
  field :name, :type => String
  
  mount_uploader :image, BoxImageUploader, :mount_on => :filename
  
  belongs_to_related :user
  
  def self.default
    BoxImage.where(:name => "Nuvens smShare").first
  end
    
end
