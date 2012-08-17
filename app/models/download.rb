class Download
  include Mongoid::Document

  field :downloaded_by_ip, :type => String
  field :downloaded_at, :type => Time
  before_create :set_downloaded_at
  field :filesize, :type => Integer
  before_create :set_filesize

  belongs_to_related :file, :class_name => "UserFile"

  belongs_to_related :file_owner, :class_name => "User"
  before_create :set_file_owner

  validates :downloaded_by_ip, :presence => true
  validates :file, :presence => true

  private
    def set_downloaded_at
      self.downloaded_at ||= Time.now.utc
    end

    def set_filesize
      self.filesize = file.filesize
    end

    def set_file_owner
      self.file_owner = file.owner
    end
end
