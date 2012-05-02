# -*- coding: utf-8 -*-
class Category
  include Mongoid::Document

  # Define o esquema logico db.categories
  field :name

  # Arquivos
  has_many_related :files, :class_name => "UserFile", :foreign_key => :category_ids

  # Validações
  validate :name, :presence => true, :uniqueness => true
end
