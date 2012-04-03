# -*- coding: utf-8 -*-
class Profile
  include Mongoid::Document

  # Campos do perfil
  field :country, :type => String
  field :state, :type => String
  field :city, :type => String
  field :zip_code, :type => String
  field :address, :type => String
  field :marital_status, :type => String
  field :gender, :type => String
  field :birthday, :type => Date
  field :company, :type => String
  field :phone_number, :type => String
  field :phone_area, :type => String
  field :mobile_phone_number, :type => String
  field :mobile_phone_area, :type => String
  field :mobile_provider, :type => String
  field :website, :type => String

  # Campos da configuração
  field :show_name, :type => Boolean
  field :show_age, :type => Boolean
  field :show_gender, :type => Boolean
  field :show_place, :type => Boolean
  field :show_website, :type => Boolean
  field :show_email, :type => Boolean
  field :description, :type => String

  # Avatar
  mount_uploader :avatar, AvatarUploader, :mount_on => :filename

  embedded_in :user, :inverse_of => :profile

end
