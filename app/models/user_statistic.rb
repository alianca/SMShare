class UserStatistic
  include Mongoid::Document

  field :files, :type => Integer
  field :files_size, :type => Integer
  field :downloads, :type => Integer
  field :referred_downloads, :type => Integer
  field :bandwidth, :type => Integer
  field :comments, :type => Integer
  field :rating, :type => Float
  field :revenue, :type => Float
  field :referred_revenue, :type => Float
  field :total_referred_revenue, :type => Float
  field :referrer_comission, :type => Float
  field :payments_received, :type => Float
  field :revenue_available_for_payment, :type => Float
  field :referred_payments_received, :type => Float
  field :referred_revenue_available_for_payment, :type => Float
  field :updated_at, :type => Time

  embedded_in :user, :inverse_of => :statistics

  def generate_statistics!
    self.files = user.files.count
    self.files_size = user.files.where(:filesize.gt => 0).sum(:filesize) || 0

    self.downloads = user.file_downloads.count
    self.referred_downloads = Download.where(:file_owner_id.in => user.referred.collect(&:_id)).count

    self.bandwidth = user.file_downloads.where(:filesize.gt => 0).sum(:filesize) || 0

    self.rating = user.files.collect(&:rate).sum
    self.comments = user.files.collect(&:comments).flatten.count

    self.revenue = downloads * 0.05
    self.total_referred_revenue = referred_downloads * 0.05
    self.referred_revenue = referred_downloads * 0.01
    self.referrer_comission = downloads * 0.01

    self.payments_received = user.payment_requests.completed.sum(:value) || 0
    self.revenue_available_for_payment = revenue - payments_received
    self.referred_payments_received = user.payment_requests.completed.sum(:referred_value) || 0
    self.referred_revenue_available_for_payment = referred_revenue - referred_payments_received

    self.updated_at = Time.now.utc
    save! if changed?
  end
end
