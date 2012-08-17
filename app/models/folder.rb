# -*- coding: utf-8 -*-
class Folder
  include Mongoid::Document
  include Mongoid::Timestamps

  # Define o esquema logico db.folders
  field :name, :type => String
  field :path, :type => String, :default => nil

  # Relações da arvore
  belongs_to_related :parent, :class_name => "Folder"
  has_many_related :children, :class_name => "Folder", :foreign_key => :parent_id
  before_validation :build_path

  before_destroy(:perform_mass_filicide)

  # Usuario
  belongs_to_related :owner, :class_name => "User"

  def files
    if self.parent
      owner.files.where(:path => "#{self.path}#{self._id}/")
    else
      owner.files.where(:path => "/")
    end
  end

  def paginate current_page, per_page
    current_page = current_page.blank? ? 1 : current_page.to_i
    total_folders = children.count
    total_files = files.count
    total_results = total_folders + total_files
    WillPaginate::Collection.create(current_page, per_page, total_results) do |pager|

      # Somente pastas
      if current_page*per_page <= total_folders
        results = children.
          order_by(:created_at => :desc).
          offset((current_page - 1) * per_page).
          limit(per_page)

      # Somente arquivos
      elsif (current_page - 1) * per_page > total_folders
        results = files.
          order_by(:created_at => :desc).
          offset((current_page - 1) * per_page-total_folders).
          limit(per_page)

      # Ambos
      else
        results = children.
          offset((current_page - 1) * per_page).
          limit(total_folders % per_page).to_a
        results += files.
          offset((current_page - 1) * per_page - total_folders + total_folders % per_page).
          limit(per_page-(total_folders%per_page)).to_a

      end
      pager.replace(results.to_a)
    end
  end

  def total_revenue
    files.collect{|f| f.statistics.revenue}.sum + children.collect(&:total_revenue).sum
  end

  def total_size
    files.collect(&:filesize).sum + children.collect(&:total_size).sum
  end

  def total_downloads
    files.collect(&:downloads_count).sum + children.collect(&:total_downloads).sum
  end

  # Remove a pasta e o conteúdo recursivamente
  def perform_mass_filicide
    self.files.each(&:destroy)
    self.children.each(&:destroy)
  end

  private

  def build_path
    fs = self.files
    cs = self.children
    if parent
      self.path = "#{parent.path}#{parent._id}/"
    else
      self.path = "/"
    end
    fs.each { |f| f.folder = self; f.save! }
    cs.each(&:save!)
  end

end
