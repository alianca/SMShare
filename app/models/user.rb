class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  # Inclui os modulos padrões do Devise. Outros disponiveis são:
  # :token_authenticatable, :confirmable, :lockable e :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  # Define o esquema logico db.users
  # email, e os campos de autenticação já são criados pelo Devise
  field :name, :type => String
  field :nickname, :type => String
  field :accepted_terms, :type => Boolean
  field :admin, :type => Boolean
  field :default_style_id, :type => BSON::ObjectId
  field :default_box_image_id, :type => BSON::ObjectId
  
  # Indicações
  belongs_to_related :referrer, :class_name => "User"
  has_many_related :referred, :class_name => "User", :foreign_key => :referrer_id
  
  # Caixa de Downloads
  has_many_related :box_styles, :foreign_key => :user_id
  has_many_related :box_images, :foreign_key => :user_id
  
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
  embeds_many :daily_statistics, :class_name => "UserDailyStatistic"# , :order => :date.asc
  
  # Validações
  validates :name, :presence => true
  validates :nickname, :presence => true, :uniqueness => true, :length => { :within => 4..32 }
  validates_acceptance_of :accepted_terms, :accept => true
  
  def self.find_for_authentication(conditions={})
    unless conditions[:email] =~ /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i # email regex
      conditions[:nickname] = conditions.delete(:email)
    end
    super
  end
  
  def default_style
    if self.default_style_id
      self.box_styles.find(self.default_style_id)
    end
  end
  
  def default_style= style
    self.default_style_id = style._id
    save
  end
  
  def default_box_image
    if self.default_box_image_id
      self.box_images.find(self.default_box_image_id)
    end
  end
  
  def default_box_image= image
    self.default_box_image_id = image._id
    save
  end
  
  private
    def build_root_folder
      self.root_folder = Folder.find_or_create_by(:owner_id => self._id, :path => "/") unless root_folder
    end
end
