# -*- coding: utf-8 -*-

class Array
  def groups_of n
    a = dup
    r = []
    while a.length > n
      r.push a.take n
      a = a.drop n
    end
    r.push a if a.length > 0
    return r
  end
end

class PaymentRequest
  include Mongoid::Document

  field :status, :type => Symbol, :default => :pending # Valid statuses: :complete, :pending, :failed
  field :payment_method, :type => Symbol # Valid methods: :paypal
  field :payment_account, :type => String
  field :value, :type => Float
  field :referred_value, :type => Float
  field :completed_at, :type => Date
  field :requested_at, :type => Date, :default => Date.today
  field :request_month, :type => Date

  belongs_to_related :user

  before_validation :set_request_month
  validate :request_month, :uniqueness => true, :scope => [:user_id]

  scope :completed, where(:status => :complete)
  scope :pending, where(:status.in => [:pending, :waiting_user])
  scope :canceled, where(:status.in => [:canceled, :refused_by_user])

#  def value
#    self.status == :pending ? user.statistics.revenue_available_for_payment : self[:value]
#  end

#  def referred_value
#    self.status == :pending ? user.statistics.referred_revenue_available_for_payment : self[:referred_value]
#  end

  def total
    value + referred_value
  end

  def request_month
    I18n.translate("date.month_names")[self[:request_month].month]
  end

  def self.graph
    graph = LazyHighCharts::HighChart.new(:graph) do |g|
      payment_requests = self.order_by(:request_month.asc).limit(12)
      g.chart(:width => 635, :height => 200, :spacingLeft => -2, :zoomType => :x)
      g.series(:name => "Valor", :type => :area, :data=> payment_requests.collect { |pr| {:name => "Valor requisitado", :y => ("%0.2f"%pr.total).to_f} })
      g.xAxis(:categories => payment_requests.collect(&:request_month))
      g.yAxis(:title => {:text => "Valor"})
      g.legend(:enabled => false)
      g.title nil
    end
  end

  SMSHARE_USER = "smshare"
  SMSHARE_PASS = "TODO_use_real_pass"
  SMSHARE_SIGN = "TODO_use_real_sign"
  PAYPAL = (if Rails.env == :production
            then "https://api-3t.paypal.com/nvp"
            else "https://api-3t.sandbox.paypal.com/nvp"
            end)

  def self.send_payments_for_month month
    general_info = [ "USER=#{SMSHARE_USER}",
                     "PWD=#{SMSHARE_PASS}",
                     "SIGNATURE=#{SMSHARE_SIGN}",
                     "METHOD=MassPay",
                     "CURRENCYCODE=BRL",
                     "RECEIVERTYPE=EmailAddress" ].join('&')

    self.
      where(:status.in => [:pending, :failed]).delete_if{|r| r.request_month != month}.to_a.
      groups_of(250).map do |group|
      [group, group.each_with_index.map{|p, i|
         "L_EMAIL#{i.to_s}=#{p.payment_account}&L_AMT#{i.to_s}=#{p.total.to_s}"
       }.join('&')]
    end.each do |r_data|
      res = CGI.parse(Curl::Easy.perform("#{PAYPAL}?#{general_info}&#{r_data[1]}").body_str)
      r_data[0].each{ |r|
        r.status = (res['ACK'] == 'Failure' ? :failed : :complete)
        r.save
        r.user.generate_statistics!
      }
    end
  end

  private

  # mes começa no dia 5
  def set_request_month
    if requested_at.day > 5
      self.request_month = Date.new(requested_at.year, requested_at.month, 1)
    else
      if requested_at.month == 1
        self.request_month = Date.new(requested_at.year-1, 12, 1)
      else
        self.request_month = Date.new(requested_at.year, requested_at.month-1, 1)
      end
    end
  end

end
