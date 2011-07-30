class UserReference
  include Mongoid::Document
  
  field :name, :type => String
  field :clicks, :type => Integer, :default => 0
  
  embedded_in :user, :inverse_of => :reference
  
  validates :name, :presence => true
  
  def signups
    user.referred.where(:referred_by => self.name).count
  end
  
  def comission
    user.referred.where(:referred_by => self.name).collect(&:'statistics.referrer_comission').sum
  end
end
