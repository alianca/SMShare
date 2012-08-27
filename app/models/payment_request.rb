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

class Hash
  def rec_to_qs(i=nil)
    map do |k, v|
      if v.class.name == 'Array'
        raise 'Invalid Request' if v.map(&:class).uniq != [Hash]
        v.each_with_index.map{|e, j| e.rec_to_qs(j)}.join('&')
      else
        "#{k.to_s.upcase}#{i.nil? ? '' : i.to_s}=" +
          case v.class.name
          when 'Symbol'
            v.to_s.split('_').map(&:capitalize).join('')
          when 'String'
            v
          when 'NilClass'
            ''
          else
            v.to_s
          end
      end
    end.join('&')
  end
end

class PaypalRequest
  def initialize method, params
    if Rails.env == :production
      @user = "TODO_use_real_user"
      @pass = "TODO_use_real_pass"
      @sign = "TODO_use_real_sign"
      @url  = "https://api-3t.paypal.com/nvp/2.0"
    else
      @user = "edric_1345742817_biz_api1.gmail.com"
      @pass = "1345742840"
      @sign = "ART7Ci0XzQG6QRx6ridAg2JWqs2CAdRXKqiSiESsfBEH-91jYhBj5vcG"
      @url  = "https://api.sandbox.paypal.com/nvp"
    end

    @method = method
    @params = params
  end

  def perform
    CGI.parse(Curl::Easy.perform("#{@url}?#{serialize}").body_str)
  end

  private

  def serialize
    { :user => @user,
      :pwd => @pass,
      :signature => @sign,
      :version => 2.3,
      :method => @method
    }.merge(@params).rec_to_qs
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

  def self.requests_for_month(m)
    self.pending.where(:request_month => Date.new(Date.today.year, m, 1))
  end

  def self.send_payments_for_month(m)
    err = []
    groups = self.requests_for_month(m).to_a.groups_of(250)
    groups.each do |group|
      res = PaypalRequest.new(:mass_pay,
                              { :currencycode => (Rails.env == :production ? 'BRL' : 'USD'),
                                :receivertype => :email_address,
                                :payments => group.map do |pr|
                                  { :l_email => pr.payment_account.to_s,
                                    :l_amt => pr.total.to_s }
                                end
                              }).perform
      group.each do |pr|
        pr.status = (res['ACK'].to_s =~ /^Success/ ? :complete : :failed)
        pr.save
      end

      if group.first.status == :failed
        err += "#{res['ACK']}[#{res['CODE']}]: #{res['L_LONGMESSAGE0']}" 
      end
    end
    return err
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
