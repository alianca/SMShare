class BoxImage
  include Mongoid::Document

  field :name, :type => String
  mount_uploader :image, BoxImageUploader, :mount_on => :filename

  belongs_to_related :user
  belongs_to_related :box_style

  validates :name, :presence => true
  validates :image, :presence => true

  before_validation :remove_invalid_name

  def self.default
    BoxImage.where(:name => "Nuvens smShare").first
  end

  def self.default_list
    BoxImage.where(:user_id => nil)
  end

  def remove_invalid_name
    self.name = "" if name == "Dê um nome para o seu fundo."
  end

end
