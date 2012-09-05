# -*- coding: utf-8 -*-

require File.expand_path('./lib/jobs/user_file_statistics_job')
require File.expand_path('./lib/jobs/user_statistics_job')

class UserFile
  include Mongoid::Document
  include Mongoid::Timestamps

  require File.expand_path('./lib/sentenced_fields')
  include SentencedFields

  # Busca
  include Tire::Model::Search
  include Tire::Model::Callbacks
  mapping do # TODO ajustar os boosts
    indexes :filename, :type => :string, :boost => 10
    indexes :filetype, :type => :string, :boost => 2
    indexes :tags, :type => :string, :index_name => :tag, :boost => 5
    indexes :categories, :type => :string, :index_name => :category, :boost => 5
    indexes :description, :type => :string, :boost => 10
  end

  # Gera o JSON para o ElasticSearch
  def to_indexed_json
    {
      :id => self._id.to_s,
      :filename => self.filename,
      :filetype => self.filetype,
      :filesize => self.filesize,
      :tag => self.tags,
      :category => self.categories.collect(&:name),
      :description => self.description,
      :created_at => self.created_at,
      :downloads_count => self.downloads_count,
      :comments_count => self.comments_count,
      :rate => self.statistics.rate,
      # Campos que precisam ser indexados pois
      # o ElasticSearch não rematerializa os resultados de busca
      :owner_id => self.owner_id,
    }.to_json
  end

  # Define o esquema logico db.user_files
  # filename já é criado pelo CarrierWave

  # Storage fields
  field :filename, :type => String
  field :filetype, :type => String
  field :filesize, :type => Integer
  field :filepath, :type => String

  # Model fields
  field :tags, :type => Array
  field :description, :type => String
  field :public, :type => Boolean, :default => true
  field :blocked, :type => Boolean, :default => false

  # File management
  belongs_to_related :folder, :inverse_of => :files

  # Usuario
  belongs_to_related :owner, :class_name => "User"

  # Categoria
  has_and_belongs_to_many :categories, :inverse_of => :files

  # Imagem
  embeds_many :images, :class_name => "UserFileImage"

  # Comentários
  embeds_many :comments

  # Denuncias
  embeds_many :reports, :class_name => "UserFileReport"

  def name
    self.filename
  end

  def name= new_name
    self.filename = new_name
  end

  # Downloads
  has_many_related :downloads, :foreign_key => :file_id

  # Estatisticas
  embeds_one :statistics, :class_name => "UserFileStatistic"
  after_create :generate_statistics_data
  after_save :needs_statistics!

  # Upload Remoto
  attr_accessor :url

  # Limpa as tags
  before_save :normalize_tags

  # Validações
  validates :owner, :presence => true
  validates :description, :presence => true
  validates :filename, :presence => true
  validates :filepath, :presence => true
  validates :filesize, :presence => true
  validates :filetype, :presence => true
  before_validation :cleanup_description

  # Sentenced Fields para as Tags
  sentenced_fields :tags

  before_save :ensure_folder

  # Remover arquivo fisico
  before_destroy :cleanup_file

  def file_extension
    File.extname(self.filename)
  end

  def file_id
    self.filepath.split('/').last
  end

  def summarize_rate
    rates = self.comments.collect{ |c| c.rate if c.rate > 0 }.compact
    rates.count > 0 ? rates.sum * 1.0 / rates.count : 0.0
  end

  def self.find_filter_and_order(query, filter, order)
    results = []
    if !query.blank?
      results = self.tire.search(query).to_a
    elsif (!filter.blank? || !order.blank?)
      results = UserFile.all.to_a
    end

    results.delete_if {|f| f.blocked?}

    if !filter.blank? && filter != "all"
      category = Category.find(filter)
      results.delete_if{ |f| !category.file_ids.include? f._id }
    end

    if !order.blank?
      begin
        results.sort!{ |a,b| b.send(order) <=> a.send(order) }
      rescue
      end
    end

    results
  end

  # Atalho para as estatísticas para ordenação

  def downloads_count
    self.statistics.downloads
  end

  def comments_count
    self.statistics.comments
  end

  def rate
    self.statistics.rate
  end

  def needs_statistics!
    Resque.enqueue Jobs::UserFileStatisticsJob, self._id
    self.owner.generate_statistics!
  end

  def cleanup_description
    if self.description == "Digite uma descrição objetiva para seu arquivo."
      self.description = nil
    end
  end

  def normalize_tags
    self.tags ||= []
    self.tags.collect! do |tag|
      tag.strip.parameterize
    end
    tags.delete("")
  end

  def generate_statistics_data
    self.create_statistics
    self.save! if changed?
  end

  def cleanup_file
    self.owner.generate_statistics!
    if [:production, :development].include? Rails.env.to_sym
      res = JSON.parse(Curl::Easy.perform("#{$file_server}:4242/files/destroy/#{self.file_id}").body_str)
      if !res['error'].nil? and res['error'] != 'enoent'
        logger.error res['error']
        raise :cleanup_fail
      end
    end
  end

  def ensure_folder
    self.folder ||= owner.root_folder
  end

end
