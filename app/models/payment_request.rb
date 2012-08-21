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

class PaypalRequest
  if Rails.env == :production
    USER = "smshare"
    PASS = "TODO_use_real_pass"
    URL = "https://api-3t.paypal.com/nvp/2.0"
  else
    USER = "smshare_test"
    PASS = "test_pass"
    URL = "https://api.sandbox.paypal.com/nvp"
  end

  def initialize method, params
    @method = method
    @params = params
  end

  def perform
    CGI.parse(Curl::Easy.perform("#{URL}?#{serialize}").body_str)
  end

  private

  def serialize
    PaypalRequest.to_qs({ :user => USER,
                          :pwd => PASS,
                          :method => @method.to_s.split('_').map(&:capitalize).join('')
                        }.merge(@params))
  end

  def self.to_qs(hash, i=nil)
    hash.map do |k, v|
      if v.class == Array
          v.each_with_index.map{|e, i| self.to_qs(e, i)}.join('&')
      else
        "#{k.to_s.upcase}#{i ? i.to_s : ''}=" +
          case v.class
          when Symbol
            v.to_s.split('_').map(&:capitalize).join('')
          when String
            v
          when Fixnum
            v.to_s
          end
      end
    end.join('&')
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
  scope :pending, where(:status.in => [:pending, :failed])

  def total
    value + referred_value
  end

  def readable_request_month
    I18n.translate("date.month_names")[self[:request_month].month]
  end

  def self.graph
    graph = LazyHighCharts::HighChart.new(:graph) do |g|
      payment_requests = self.order_by(:request_month.asc).limit(12)
      g.chart(:width => 635, :height => 200, :spacingLeft => -2, :zoomType => :x)
      g.series(:name => "Valor",
               :type => :area,
               :data=> payment_requests.collect do |pr|
                 {:name => "Valor requisitado", :y => ("%0.2f"%pr.total).to_f}
               end)
      g.xAxis(:categories => payment_requests.collect(&:request_month))
      g.yAxis(:title => {:text => "Valor"})
      g.legend(:enabled => false)
      g.title nil
    end
  end


  def self.requests_for_month m
    self.pending.where(:request_month => Date.new(Date.today.year, m, 1))
  end

  def self.payment_info_for_month m
    self.requests_for_month(m).to_a.groups_of(250)
  end

  def self.send_payments_for_month m
    payments = self.payment_info_for_month(m)
    payments.each do |p|
      request = PaypalRequest.new(:mass_pay,
                                  {
                                    :currencycode => 'BRL',
                                    :receivertype => :email_address,
                                    :payments => p.map{|p|
                                      {
                                        :l_email => p.payment_account.to_s,
                                        :l_amt => p.total.to_s
                                      }
                                    }
                                  }).perform

      p.each do |pr|
        if request['ACK'] == 'Success'
          pr[0].status = :complete
        else
          pr[0].status = :failed
        end
      end
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
