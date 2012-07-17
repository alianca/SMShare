class Comment
  include Mongoid::Document
  include Mongoid::Timestamps

  field :message, :type => String
  field :rate, :type => Integer
  field :blocked, :type => Boolean

  embedded_in :file, :class_name => "UserFile", :inverse_of => :comments
  belongs_to_related :owner, :class_name => "User"

  embeds_many :answers, :class_name => "Answer"

  def self.search a_query
    fields_to_search = ["alias", "filename", "comments.message"]

    regex_for_query = Regexp.new a_query.gsub(" ", "|"), "i"

    mongodb_query = { "$or" => fields_to_search.collect { |f| { f => regex_for_query } } }
    UserFile.where(mongodb_query).collect do |uf|
      results = uf.comments.where("message" => regex_for_query).all
      results = uf.comments.all if results.empty?

      results
    end.flatten.compact
  end
end
