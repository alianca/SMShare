class UserReference
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :clicks, :type => Integer, :default => 0

  embedded_in :user, :inverse_of => :reference

  validates :name, {
    :presence => true,
    :uniqueness => true
  }

  before_create :sanitize_name

  def signups
    referees.count
  end

  def comission
    referees.collect{|r| r.statistics.referrer_comission}.sum
  end

  def got_click
    self.clicks += 1
    save!
  end

  def referees
    self.user.referred.where(:referred_by => self.name).compact
  end

  private

  def sanitize_name
    self.name.gsub! /[^\w_]/, '-'
  end
end
