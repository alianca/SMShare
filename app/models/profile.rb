class Profile
  include Mongoid::Document
  
  # Campos do perfil
  field :birthday, :type => Date
  field :location, :type => String
  field :website, :type => String
  field :gender, :type => String
  
  # Campos da configuração
  field :show_name, :type => Boolean
  field :show_age, :type => Boolean
  field :show_gender, :type => Boolean
  field :show_place, :type => Boolean
  field :show_website, :type => Boolean
  field :show_email, :type => Boolean
  field :description, :type => String
  
  embeds_one :avatar
  
  embedded_in :user, :inverse_of => :profile
  
end

