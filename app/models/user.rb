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
  belongs_to_related :referrer, :class_name => User  
end
