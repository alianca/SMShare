class News
  include Mongoid::Document

  field :short, :type => String
  field :full, :type => String
end
