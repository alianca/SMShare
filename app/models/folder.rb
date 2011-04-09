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
  
  def to_param
    "#{self.path}#{self._id}/".gsub(/^\/|\/$/, "")
  end
  
  def paginate current_page, per_page
    current_page = current_page.blank? ? 1 : current_page.to_i    
    total_folders = children.count
    total_files = files.count
    total_results = total_folders + total_files
    WillPaginate::Collection.create(current_page, per_page, total_results) do |pager|
      if current_page*per_page <= total_folders # só tem pastas
        results = children.order_by(:name => :asc, :created_at => :asc).offset((current_page-1)*per_page).limit(per_page)
      elsif (current_page-1)*per_page > total_folders # só tem arquivos
        results = files.order_by(:name => :asc, :created_at => :asc).offset((current_page-1)*per_page-total_folders).limit(per_page)
      else # fodeu, tem arquivo e pasta
        results = children.order_by(:name => :asc, :created_at => :asc).offset((current_page-1)*per_page).limit(total_folders%per_page).to_a
        results += files.order_by(:name => :asc, :created_at => :asc).offset((current_page-1)*per_page-total_folders+1).limit(per_page-(total_folders%per_page)).to_a
      end
      pager.replace(results.to_a)
    end
  end
  
  private
    def build_path
      self.path = "#{parent.path}#{parent._id}/" if parent
    end
end
