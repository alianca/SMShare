class UserFileStatistic
  include Mongoid::Document

  field :downloads, :type => Integer
  field :comments, :type => Integer
  field :rate, :type => Float
  field :bandwidth, :type => Integer
  field :revenue, :type => Float
  field :updated_at, :type => Time

  embedded_in :file, :class_name => "UserFile", :inverse_of => :statistics

  def generate_statistics!
    self.downloads = self.file.downloads.count || 0
    self.comments = self.file.comments.count || 0
    self.rate = self.file.summarize_rate || 0.0
    self.bandwidth = self.file.downloads.where(:filesize.gt => 0).sum(:filesize) || 0
    self.revenue = self.downloads * 0.5

    self.updated_at = Time.now.utc

    save! if changed?
  end
end
