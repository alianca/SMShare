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

  def box_image
    BoxImage.find(self.box_image_id)
  rescue
    BoxImage.default
  end

  def self.default
    BoxStyle.where(:name => "Estilo smShare").first
  end

  def self.defaults
    styles = BoxStyle.where(:user => nil).to_a
    styles.sort { |a, b| a.order <=> b.order }
  end

end
