# -*- coding: utf-8 -*-
class UserFile
  include Mongoid::Document
  include Mongoid::Timestamps

  require "lib/sentenced_fields"
  include SentencedFields

  # Busca
  include Tire::Model::Search
  include Tire::Model::Callbacks
  mapping do # TODO ajustar os boosts
    indexes :id, :type => :string, :analyzed => false
    indexes :alias, :type => :string, :boost => 10
    indexes :filetype, :type => :string, :boost => 2
    indexes :tags, :type => :string, :index_name => :tag, :boost => 5
    indexes :categories, :type => :string, :index_name => :category, :boost => 5
    indexes :description, :type => :string
    indexes :created_at, :type => :date, :analyzed => false
    indexes :downloads_count, :type => :integer, :boost => 2
    indexes :comments_count, :type => :integer
    indexes :rate, :type => :float, :index_name => :rating, :boost => 3
  end

  # Gera o JSON para o ElasticSearch
  def to_indexed_json
    {
      :id => self._id.to_s,
      :alias => self.alias,
      :filetype => self.filetype,
      :tag => self.tags,
      :category => self.categories.collect(&:name),
      :description => self.description,
      :created_at => self.created_at,
      :downloads_count => self.statistics.downloads,
      :comments_count => self.comments.count,
      :rate => self.rate,
      # Campos que precisam ser indexados pois
      # o ElasticSearch não rematerializa os resultados de busca
      :owner_id => self.owner_id,
      :filename => self.filename,
    }.to_json
  end

  # Define o esquema logico db.user_files
  # filename já é criado pelo CarrierWave
  field :tags, :type => Array
  field :description, :type => String
  field :filetype, :type => String
  field :filesize, :type => Integer
  field :rate, :type => Float, :default => 0.0
  field :public, :type => Boolean, :default => true
  field :path, :type => String, :default => "/"
  field :blocked, :type => Boolean, :default => false

  # O GridFS não permite alterar o nome de um arquivo existente
  # Então criei um campo alias para poder renomear os arquivos
  field :alias, :type => String
  before_save :generate_alias

  # Usuario
  belongs_to_related :owner, :class_name => "User"

  # Imagem
  has_many_related :images, :class_name => "UserFileImage", :stored_as => :array

  # Categoria
  has_many_related :categories, :stored_as => :array

  # Comentários
  embeds_many :comments

  # Denuncias
  embeds_many :reports, :class_name => "UserFileReport"

  # Pasta
  def folder
    owner.folders.where(:path => path).first
  end

  def folder= a_folder
    self.path = a_folder.path
  end

  # Arquivo
  mount_uploader :file, UserFileUploader, :mount_on => :filename
  after_save :cache_filetype, :cache_filesize

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

  def resolve_filetype
    case self.filetype
    when /image.*/
      { :name => "Gráfico",
        :icon => "search/icone-grafico.png",
        :thumb => "search/thumb-grafico.png" }
    when /application.*/
      case self.filetype
      when /application\/(x-gzip|x-tar|zip|x-rar)/
        { :name => "Compactado",
          :icon => "search/icone-compactado.png",
          :thumb => "search/thumb-compactado.png" }
      when /application\/(word|rtf|pdf|postscript)/
        { :name => "Documento",
          :icon => "search/icone-documento.png",
          :thumb => "search/thumb-documento.png" }
      else
        { :name => "Programa",
          :icon => "search/icone-programa.png",
          :thumb => "search/thumb-programa.png" }
      end
    when /audio.*/
      { :name => "Áudio",
        :icon => "search/icone-audio.png",
        :thumb => "search/thumb-audio.png" }
    when /video.*/
      { :name => "Vídeo",
        :icon => "search/icone-video.png",
        :thumb => "search/thumb-video.png" }
    when /text\/(html|javascript|css)/
      { :name => "Web",
        :icon => "search/icone-web.png",
        :thumb => "search/thumb-web.png" }
    when /application\/(jar|vnd.android.package-archive)/
      { :name => "Móvel",
        :icon => "search/icone-mobile.png",
        :thumb => "search/thumb-mobile.png" }
    else
      { :name => self.filetype,
        :icon => "search/icone-other.png",
        :thumb => "search/thumb-other.png" }
    end
  end

  def file_extension
    File.extname(self.alias)
  end

  def validate_code(code)
    code == '12345'
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
      tempfile = File.open(Rails.root +
                           "tmp/tempfiles/user_file/#{self.id}/#{filename}",
                           "w")
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
    if self.description == "Digite uma descrição objetiva para seu arquivo."
      self.description = nil
    end
  end

  def normalize_tags
    tags.collect! do |tag|
      tag.strip.parameterize
    end
    tags.delete("")
  end

  def generate_alias
    self.alias ||= self.filename
  end
end
