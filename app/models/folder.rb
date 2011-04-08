class Folder
  include Mongoid::Document
  
  # Define o esquema logico db.folders  
  field :name, :type => String
  field :path, :type => String, :default => "/"
  
  # Relações da arvore
  belongs_to_related :parent, :class_name => "Folder"
  has_many_related :children, :class_name => "Folder", :foreign_key => :parent_id
  after_save :build_path
    
  # Usuario
  belongs_to_related :owner, :class_name => "User"
  
  # Arquivos
  # has_many_related :files, :class_name => "UserFile", :primary_key => :path, :foreign_key => :path
  def files
    UserFile.where(:path => path, :owner_id => owner_id)
  end   
  
  private
    def build_path
      self.path = "#{parent.path}#{parent._id}/" if parent
    end
end
