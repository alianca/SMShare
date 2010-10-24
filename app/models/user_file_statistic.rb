class UserFileStatistic
  include Mongoid::Document
  
  field :downloads, :type => Integer
  field :bandwidth, :type => Integer
  field :updated_at, :type => Time
  
  embedded_in :file, :class_name => "UserFile", :inverse_of => :statistics
  
  def generate_statistics!
    self.downloads = file.downloads.count  
    self.bandwidth = file.downloads.where(:filesize.gt => 0).sum(:filesize) || 0
    
    self.updated_at = Time.now.utc
    save! if changed?
  end
end
