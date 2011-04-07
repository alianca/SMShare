class News
  include Mongoid::Document

  field :short, :type => String
  field :full, :type => String
  
  validates_presence_of :short
  validates_presence_of :full
end
