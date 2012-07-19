class BoxImage
  include Mongoid::Document

  field :name, :type => String
  mount_uploader :image, BoxImageUploader, :mount_on => :filename

  belongs_to_related :user
  belongs_to_related :box_style

  def self.default
    BoxImage.where(:name => "Nuvens smShare").first
  end

  def self.default_list
    BoxImage.where(:user => nil).to_a
  end

end
