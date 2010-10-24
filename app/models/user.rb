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

  # Indicações
  belongs_to_related :referrer, :class_name => "User"
  has_many_related :referred, :class_name => "User", :foreign_key => :referrer_id
  
  # Arquivos
  has_many_related :files, :class_name => "UserFile", :foreign_key => :owner_id
  has_many_related :file_downloads, :class_name => "Download", :foreign_key => :file_owner_id
  
  # Estatisticas
  embeds_one :statistics, :class_name => "UserStatistic"
  after_create :build_statistics
  embeds_many :daily_statistics, :class_name => "UserDailyStatistic"# , :order => :date.asc
  
  # Validações
  validates_presence_of :name
  validates_presence_of :nickname
  validates_uniqueness_of :nickname
  validates_length_of :nickname, :within => 4..32
  validates_acceptance_of :accepted_terms, :accept => true
  
  def self.find_for_authentication(conditions={})
    unless conditions[:email] =~ /^([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})$/i # email regex
      conditions[:nickname] = conditions.delete(:email)
    end
    super
  end
end
