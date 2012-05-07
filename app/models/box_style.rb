class BoxStyle
  include Mongoid::Document

  field :box_background, :type => String
  field :box_border, :type => String
  field :header_background, :type => String
  field :box_background_image, :type => BSON::ObjectId
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

  def self.default
    BoxStyle.where(:name => "Estilo smShare").first
  end

  def self.defaults
    styles = BoxStyle.where(:user => nil).to_a
    styles.sort { |a, b| a.order <=> b.order }
  end

end
