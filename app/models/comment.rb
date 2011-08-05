class Comment
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :message, :type => String
  field :rate, :type => Integer
  field :blocked, :type => Boolean
  
  embedded_in :file, :class_name => "UserFile", :inverse_of => :comments
  belongs_to_related :owner, :class_name => "User"
  
  def self.search a_query    
    UserFile.where("comments.message" => a_query).collect do |uf|
      uf.comments.where("message" => a_query)
    end.flatten
  end
end
