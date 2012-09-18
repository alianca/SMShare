# -*- coding: utf-8 -*-

require File.expand_path('./lib/jobs/user_statistics_job')

EMAIL_REGEX = /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i

class User
  include Mongoid::Document
  include Mongoid::Timestamps

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  field :sign_in_count,        :type => Integer, :default => 0
  field :current_sign_in_at,   :type => Time
  field :last_sign_in_at,      :type => Time
  field :current_sign_in_ip,   :type => String
  field :last_sign_in_ip,      :type => String
  field :remember_created_at,  :type => Time
  field :encrypted_password,   :type => String

  # Define o esquema logico db.users
  field :name,                 :type => String
  field :email,                :type => String
  field :nickname,             :type => String
  field :accepted_terms,       :type => Boolean
  field :default_box_style_id, :type => BSON::ObjectId
  field :default_box_image_id, :type => BSON::ObjectId
  field :admin,                :type => Boolean, :default => false
  field :blocked,              :type => Boolean, :default => false
  field :referred_by,          :type => String

  # Indicações
  belongs_to_related :referrer, :class_name => "User"
  has_many_related   :referred, :class_name => "User", :foreign_key => :referrer_id

  # Referencias
  embeds_many :references, :class_name => "UserReference"

  # Caixa de Downloads
  has_many_related :box_styles, :inverse_of => :user
  has_many_related :box_images, :inverse_of => :user

  # Arquivos
  has_many_related :files,          :class_name => "UserFile", :foreign_key => :owner_id
  has_many_related :file_downloads, :class_name => "Download", :foreign_key => :file_owner_id

  # Pastas
  has_many_related :folders,     :foreign_key => :owner_id
  has_one_related  :root_folder, :foreign_key => :owner_id, :class_name => "Folder"
  after_save :build_root_folder

  # Estatisticas
  embeds_one   :statistics,       :class_name => "UserStatistic"
  embeds_many  :daily_statistics, :class_name => "UserDailyStatistic"
  after_create :build_statistics!

  # Perfil
  embeds_one   :profile, :class_name => "Profile"
  after_create :create_profile

  # Requisições de Pagamento
  has_many_related :payment_requests

  # Denuncias
  embeds_many :reports, :class_name => "UserReport"

  # Validações
  validates :name, :presence => true
  validates :nickname, {
    :presence => true,
    :uniqueness => true,
    :length => { :within => 4..32 }
  }
  validates_acceptance_of :accepted_terms, :accept => true

  def self.find_for_authentication(conditions={})
    unless conditions[:email] =~ EMAIL_REGEX
      conditions[:nickname] = conditions.delete(:email)
    end
    conditions[:blocked] = false
    super
  end


  def default_box_style= style
    self.default_box_style_id = style._id
    self.default_box_image_id = nil
  end

  def default_box_style
    begin
      BoxStyle.find(default_box_style_id)
    rescue
      box_styles.find(default_box_style_id)
    end
  rescue StandardError => e
    BoxStyle.default
  end


  def default_box_image= image
    self.default_box_image_id = image._id
  end

  def default_box_image
    begin
      BoxImage.find(default_box_image_id)
    rescue
      box_images.find(default_box_image_id)
    end
  rescue
    default_box_style.box_image
  end


  def age
    if (self.profile.birthday)
      ((Date.today - self.profile.birthday) / 365.25).to_i
    else
      nil
    end
  end

  def downloads_for date
    file_downloads.
      where(:downloaded_at.gte => date.to_time.utc.beginning_of_day).
      where(:downloaded_at.lte => date.to_time.utc.end_of_day).
      count
  end

  def generate_statistics!
    UserDailyStatistic.generate_statistics_for_user! self
    self.statistics.generate_statistics!
  end

  after_authentication :generate_statistics!

  private

  def build_statistics!
    self.create_statistics
    self.statistics.generate_statistics!
  end

  def build_root_folder
    self.root_folder = self.folders.create(:path => "/") unless root_folder
  end

end
