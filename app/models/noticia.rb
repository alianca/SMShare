class Noticia
  include Mongoid::Document

  field :resumida, :type => String
  field :completa, :type => String
end
