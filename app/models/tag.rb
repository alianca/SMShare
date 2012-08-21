# -*- coding: utf-8 -*-
class Tag
  include Mongoid::Document

  # Define o esquema logico db.tags
  field :name

  # Relações

  # has_many_related :files, :class_name => "UserFile", :primary_key => :name, :foreign_key => :tags
  def files
    UserFile.where(:tags => self.name)
  end

  # Consolida as tags com as tags existentes nos arquivos
  def self.consolidate!
    user_file_tags = UserFile.all.collect(&:tags).flatten.uniq # Fazer via MapReduce
    consolidated_tags = Tag.all.collect(&:name)

    # Cria as novas tags
    (user_file_tags-consolidated_tags).each do |tag|
      self.create!(:name => tag)
    end

    # Apaga as tags que não existem mais
    self.where(:name.in => (consolidated_tags-user_file_tags)).destroy_all

    # Retorna true se chegou até aqui
    true
  end
end
