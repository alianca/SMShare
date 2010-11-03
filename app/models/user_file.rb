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
  field :public, :type => Boolean, :default => true
  
  # Usuario
  belongs_to_related :owner, :class_name => "User"
  
  # Arquivo
  mount_uploader :file, UserFileUploader, :mount_on => :filename
  after_save :cache_filetype, :cache_filesize # TODO descobrir como fazer isso em um unico passo
  
  # Downloads
  has_many_related :downloads, :foreign_key => :file_id
  
  # Estatisticas
  embeds_one :statistics, :class_name => "UserFileStatistic"
  after_create :build_statistics

  # Upload Remoto
  attr_writer :url
  before_validation :download_file_from_url
  
  # Validações  
  validates_presence_of :owner
  validates_presence_of :file
  validates_presence_of :description
  before_validation :cleanup_description
  
  private  
    def cache_filetype
      self.filetype = self.file.file.content_type
      save if changed?
    end
    
    def cache_filesize
      self.filesize = self.file.file.file_length
      save if changed?
    end

    def download_file_from_url
      if @url
        uri = URI.parse(@url)
        tempfile = Tempfile.new(uri.path)        
        tempfile.write Net::HTTP.get_response(uri).body
        tempfile.flush
        self.file = tempfile
      end
    end
    
    def cleanup_description
      self.description = nil if self.description == "Digite uma descrição objetiva para seu arquivo."
    end
end
