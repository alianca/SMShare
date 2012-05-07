# -*- coding: utf-8 -*-
class Category
  include Mongoid::Document

  # Define o esquema logico db.categories
  field :name

  # Arquivos
  has_and_belongs_to_many :files, :class_name => "UserFile"

  # Validações
  validate :name, :presence => true, :uniqueness => true
end
