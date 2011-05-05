class UserFile
  include Mongoid::Document
  include Mongoid::Timestamps
  
  require "lib/sentenced_fields"
  include SentencedFields
  
  # Define o esquema logico db.user_files
  # filename já é criado pelo CarrierWave
  
  # O GridFS não permite alterar o nome de um arquivo existente
  # Então criei um campo alias para poder renomear os arquivos
  field :alias, :type => String
  field :tags, :type => Array
  field :description, :type => String
  field :filetype, :type => String
  field :filesize, :type => Integer
  field :rate_sum, :type => Integer, :default => 0
  field :ratings, :type => Integer, :default => 0
  field :public, :type => Boolean, :default => true
  field :path, :type => String, :default => "/"
  
  # Usuario
  belongs_to_related :owner, :class_name => "User"
  
  # Categoria
  has_many_related :categories, :stored_as => :array
  
  # Comentários
  has_many_related :comments, :stored_as => :array
  
  # Pasta
  def folder
    owner.folders.where(:path => path).first
  end
  
  def folder= a_folder
    self.path = a_folder.path
  end
  
  # Arquivo
  mount_uploader :file, UserFileUploader, :mount_on => :filename
  after_save :cache_filetype, :cache_filesize # TODO descobrir como fazer isso em um unico passo
  
  # Downloads
  has_many_related :downloads, :foreign_key => :file_id
  
  # Estatisticas
  embeds_one :statistics, :class_name => "UserFileStatistic"
  after_create :build_statistics

  # Upload Remoto
  attr_accessor :url
  before_validation :download_file_from_url
  after_save :cleanup_tempfile
  
  # Limpa as tags
  before_save :normalize_tags
  
  # Validações  
  validates :owner, :presence => true
  validates :file, :presence => true
  validates :description, :presence => true
  before_validation :cleanup_description
  
  # Sentenced Fields para as Tags
  sentenced_fields :tags
  
  def self.search query_string
    fields_to_search = ["alias", "filename", "filetype", "description", "tags", "categories"]

    regex_for_query = Regexp.new query_string.gsub(" ", "|"), "i"

    mongodb_query = { "$or" => fields_to_search.collect { |f| { f => regex_for_query } } }
    self.where(mongodb_query)
  end
  
  
  def copy_filename
    self.alias = self.filename
    self.save!
  end
  
  def filetype_human_readable
    case self.filetype
      when "image/png"
        "Imagem PNG"
      else
        self.filetype
    end
  end
  
  def add_rate(rate)
    self.rate_sum += rate
    self.ratings += 1
    save
  end
  
  def rate
    if self.ratings > 0
      self.rate_sum*1.0/self.ratings
    else
      0
    end
  end

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
        filename = uri.path.match(/.*\/(.*)/)[1]
        filename = uri.host if filename.blank?
        FileUtils.mkdir_p(Rails.root + "tmp/tempfiles/user_file/#{self.id}")
        tempfile = File.open(Rails.root + "tmp/tempfiles/user_file/#{self.id}/#{filename}", "w")
        tempfile.write Curl::Easy.perform(uri.to_s).body_str
        tempfile.flush
        self.file = tempfile
      end
    end
    
    def cleanup_tempfile
      if File.directory?(Rails.root + "tmp/tempfiles/user_file/#{self.id}")
        FileUtils.remove_dir(Rails.root + "tmp/tempfiles/user_file/#{self.id}")
      end
    end
        
    def cleanup_description
      self.description = nil if self.description == "Digite uma descrição objetiva para seu arquivo."
    end
    
    def normalize_tags
      tags.collect! do |tag|
        tag.strip.parameterize
      end
      tags.delete("")
    end
end
