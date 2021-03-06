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
  field :birthday_, :type => Date
  field :company, :type => String
  field :phone_number, :type => String
  field :phone_area, :type => String
  field :mobile_phone_number, :type => String
  field :mobile_phone_area, :type => String
  field :mobile_provider, :type => String
  field :website, :type => String
  field :count, :type => Integer, :default => 0

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

  def birthday
    self.birthday_ ||= Date.new
  end

  def method_missing method_sym, *args
    case method_sym.to_s
    when /^birthday_(.+)=$/
      self.birthday_ = Date.new(
        $1 == 'year'  ? args[0].to_i : birthday_year,
        $1 == 'month' ? args[0].to_i : birthday_month,
        $1 == 'day'   ? args[0].to_i : birthday_day
      )
    when /^birthday_(.+)$/
      self.birthday.send($1.to_sym)
    else
      super
    end
  end

  def has_been_seen
    self.count += 1
    self.save
  end

end
