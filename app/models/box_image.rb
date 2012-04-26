class BoxImage
  include Mongoid::Document

  field :name, :type => String
  field :order, :type => Integer, :default => 0

  mount_uploader :image, BoxImageUploader, :mount_on => :filename

  belongs_to_related :user

  def self.default
    BoxImage.where(:name => "Nuvens smShare").first
  end

  def self.default_list
    images = BoxImage.where(:user => nil).to_a
    images.sort { |a, b| a.order <=> b.order }
  end

end
