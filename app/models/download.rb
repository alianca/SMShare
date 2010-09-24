class Download
  include Mongoid::Document
  
  field :downloaded_by_ip, :type => String
  field :downloaded_at, :type => Time
  before_create :set_downloaded_at

  belongs_to_related :file, :class_name => "UserFile"
  
  validates_presence_of :downloaded_by_ip
  validates_presence_of :file

  private
    def set_downloaded_at
      self.downloaded_at = Time.now.utc if !downloaded_at
    end  
end
