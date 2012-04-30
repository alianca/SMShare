# -*- coding: utf-8 -*-

require 'lib/jobs/user_statistics_job'

class User
  include Mongoid::Document
  include Mongoid::Timestamps


  ## Database_authenticatable
  field :email,              :type => String, :null => false
  field :encrypted_password, :type => String, :null => false

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String



  # Define o esquema logico db.users
  field :name, :type => String
  field :nickname, :type => String
  field :accepted_terms, :type => Boolean
  field :default_style_id, :type => BSON::ObjectId
  field :default_box_image_id, :type => BSON::ObjectId
  field :admin, :type => Boolean, :default => false
  field :blocked, :type => Boolean, :default => false
  field :referred_by, :type => String

  # Indicações
  belongs_to_related :referrer, :class_name => "User"
  has_many_related :referred, :class_name => "User", :foreign_key => :referrer_id

  # Referencias
  embeds_many :references, :class_name => "UserReference"

  # Caixa de Downloads
  has_many_related :box_styles, :foreign_key => :user_id
  has_many_related :box_images, :foreign_key => :user_id
  before_save :set_default_box_style

  # Arquivos
  has_many_related :files, :class_name => "UserFile", :foreign_key => :owner_id
  has_many_related :file_downloads, :class_name => "Download", :foreign_key => :file_owner_id

  # Pastas
  has_many_related :folders, :foreign_key => :owner_id
  belongs_to_related :root_folder, :class_name => "Folder"
  before_save :build_root_folder

  # Estatisticas
  embeds_one :statistics, :class_name => "UserStatistic"
  after_create :build_statistics
  embeds_many :daily_statistics, :class_name => "UserDailyStatistic" # , :order => :date.asc
  after_create :generate_statistics!

  # Perfil
  embeds_one :profile, :class_name => "Profile"
  after_create :create_profile

  # Requisições de Pagamento
  has_many_related :payment_requests

  # Denuncias
  embeds_many :reports, :class_name => "UserReport"

  # Validações
  validates :name, :presence => true
  validates :nickname, :presence => true, :uniqueness => true, :length => { :within => 4..32 }
  validates_acceptance_of :accepted_terms, :accept => true

  def self.find_for_authentication(conditions={})
    unless conditions[:email] =~ /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i # email regex
      conditions[:nickname] = conditions.delete(:email)
    end
    conditions[:blocked] = false
    super
  end

  def default_style
    BoxStyle.find(self.default_style_id) if self.default_style_id
  end

  def default_style= style
    self.default_style_id = style._id
  end

  def default_box_image
    BoxImage.find(self.default_box_image_id) if self.default_box_image_id
  end

  def default_box_image= image
    self.default_box_image_id = image._id
  end

  def age
    if (self.profile.birthday)
      ((Date.today - self.profile.birthday) / 365.25).to_i
    else
      nil
    end
  end

  def downloads_for date
    file_downloads.where(:downloaded_at.gte => date.to_time.utc.beginning_of_day).where(:downloaded_at.lte => date.to_time.utc.end_of_day).count
  end

  def generate_statistics!
    UserDailyStatistic.generate_statistics_for_user! self
    self.statistics.generate_statistics!
  end

  private

  def build_root_folder
    self.root_folder = Folder.find_or_create_by(:owner_id => self._id, :path => "/") unless root_folder
  end

  def set_default_box_style
    self.default_style ||= BoxStyle.default
    self.default_box_image ||= BoxImage.default
  end

end
