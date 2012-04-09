class UserFileStatistic
  include Mongoid::Document

  field :downloads, :type => Integer
  field :comments, :type => Integer
  field :rate, :type => Float
  field :bandwidth, :type => Integer
  field :revenue, :type => Float
  field :updated_at, :type => Time

  embedded_in :file, :class_name => "UserFile", :inverse_of => :statistics

  after_create :generate_statistics!

  def generate_statistics!
    self.downloads = file.downloads.count
    self.comments = file.comments.count
    self.rate = file.summarize_rate
    self.bandwidth = file.downloads.where(:filesize.gt => 0).sum(:filesize) || 0
    self.revenue = downloads * 0.5

    self.updated_at = Time.now.utc

    save! if changed?
  end
end
