class News
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :title, :type => String
  field :short, :type => String
  field :full, :type => String
  
  validates :title, :presence => true
  validates :short, :presence => true
  validates :full, :presence => true
end
