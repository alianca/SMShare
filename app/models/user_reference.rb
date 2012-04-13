class UserReference
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :clicks, :type => Integer, :default => 0

  embedded_in :user, :inverse_of => :reference

  validates :name, :presence => true

  def signups
    user.referred.where(:referred_by => self.name).count
  end

  def comission
    self.user.referred.where(:referred_by => self.name).collect{|r| r.statistics.referrer_comission}.sum
  end

  def got_click
    self.clicks += 1
    save!
  end
end
