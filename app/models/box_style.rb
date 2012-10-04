class BoxStyle
  include Mongoid::Document

  field :box_background, :type => String
  field :box_border, :type => String
  field :header_background, :type => String
  field :header_text, :type => String
  field :upper_text, :type => String
  field :number_text, :type => String
  field :para_text, :type => String
  field :cost_text, :type => String
  field :form_background, :type => String
  field :form_border, :type => String
  field :form_text, :type => String
  field :button_background, :type => String
  field :button_text, :type => String
  field :bottom_text, :type => String
  field :name, :type => String
  field :order, :type => Integer, :default => 0

  belongs_to_related :user

  has_one_related :box_image, :foreign_key => :box_style_id

  validates :name, :presence => true

  before_validation :remove_invalid_name

  def box_image
    BoxImage.find(self.box_image_id)
  rescue
    BoxImage.default
  end

  def self.default
    BoxStyle.where(:name => "Estilo smShare").first
  end

  def self.default_list
    self.where(:user_id => nil)
  end

  def remove_invalid_name
    self.name = "" if name == "Dê um nome para o modelo..."
  end

end
