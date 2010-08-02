class UserFile
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # Define o esquema logico db.user_files
  # filename, filetype, e filesize vão ser criados e matidos pelo CarrierWave
  field :categories, :type => Array
  field :tags, :type => Array
  field :description, :type => String
  
  # Usuario
  belongs_to_related :owner, :class_name => "User"
  
  # Arquivo
  mount_uploader :file, UserFileUploader, :mount_on => "filename"
end
