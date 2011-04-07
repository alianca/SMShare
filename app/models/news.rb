class News
  include Mongoid::Document
  
  field :title, :type => String
  field :short, :type => String
  field :full, :type => String
  field :date, :type => Time
  
  validates_presence_of :title
  validates_presence_of :short
  validates_presence_of :full
end
