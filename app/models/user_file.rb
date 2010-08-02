class UserFile
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # Define o esquema logico db.user_files
  # filename já é criado pelo CarrierWave
  field :categories, :type => Array
  field :tags, :type => Array
  field :description, :type => String
  field :filetype, :type => String
  field :filesize, :type => Integer
  
  # Usuario
  belongs_to_related :owner, :class_name => "User"
  
  # Arquivo
  mount_uploader :file, UserFileUploader, :mount_on => :filename
  after_save :cache_filetype, :cache_filesize # TODO descobrir como fazer isso em um unico passo  
  
  private
    def cache_filetype
      self.filetype = self.file.file.content_type
      save if changed?
    end
    
    def cache_filesize
      self.filesize = self.file.file.file_length
      save if changed?
    end
end
