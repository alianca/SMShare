class UserStatistic
  include Mongoid::Document
  
  field :files, :type => Integer
  field :files_size, :type => Integer
  field :downloads, :type => Integer
  field :referred_downloads, :type => Integer
  field :bandwidth, :type => Integer
  field :comments, :type => Integer
  field :rating, :type => Float
  field :revenue, :type => Float
  field :referred_revenue, :type => Float
  field :updated_at, :type => Time
  
  embedded_in :user, :inverse_of => :statistics
  
  def generate_statistics!
    self.files = user.files.count
    self.files_size = user.files.where(:filesize.gt => 0).sum(:filesize) || 0
    
    self.downloads = user.file_downloads.count
    self.referred_downloads = Download.where(:file_owner_id.in => user.referred.collect(&:_id)).count
    
    self.bandwidth = user.file_downloads.where(:filesize.gt => 0).sum(:filesize) || 0
    
    rated_files = user.files.where(:rating.gt => 0)
    self.rating = rated_files.sum(:rating) / rated_files.count || 0
    self.comments = rated_files.count
    
    self.revenue = downloads * 0.0 # needs to be defined with Came
    self.referred_revenue = referred_downloads * 0.0 # needs to be defined with Came
    
    self.updated_at = Time.now.utc
    save! if changed?
  end
end
