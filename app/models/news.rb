class News
  include Mongoid::Document
  
  field :title, :type => String
  field :short, :type => String
  field :full, :type => String
  field :date, :type => Time
  
  validates :title, :presence => true
  validates :short, :presence => true
  validates :full, :presence => true
end
