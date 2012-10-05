# -*- coding: utf-8 -*-
class Folder
  include Mongoid::Document
  include Mongoid::Timestamps

  # Define o esquema logico db.folders
  field :name, :type => String
  field :path, :type => String, :default => nil

  # Relações da arvore
  belongs_to_related :parent,   :class_name => "Folder"
  has_many_related   :children, :class_name => "Folder", :foreign_key => :parent_id
  before_save  :build_path

  before_destroy(:perform_mass_filicide)

  # Usuario
  belongs_to_related :owner, :class_name => "User"

  has_many_related :files, :class_name => "UserFile"

  def method_missing method_sym
    if method_sym.to_s =~ /^total_(.+)$/
      (files + children).map(&method_sym).sum
    else
      super
    end
  end

  # Remove a pasta e o conteúdo recursivamente
  def perform_mass_filicide
    self.files.each(&:destroy)
    self.children.each(&:destroy)
  end

  validates :owner, :presence => true

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
