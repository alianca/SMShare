# -*- coding: utf-8 -*-

def to_nvp(hash, i=nil)
  hash.map do |k, v|
    if v.class.name == 'Array'
      raise 'Invalid Request' if v.map(&:class).uniq != [Hash]
      v.each_with_index.map{|e,j| to_nvp(e, j)}.join('&')
    else
      "#{i.nil? ? '' : 'L_'}#{k.to_s.upcase}#{i.nil? ? '' : i.to_s}=" +
        case v.class.name
        when 'Symbol': v.to_s.camelize
        when 'String': v
        when 'NilClass': ''
        else v.to_s
        end
    end 
  end.join('&')
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
    to_nvp({
      :user => @user,
      :pwd => @pass,
      :signature => @sign,
      :version => 2.3,
      :method => @method
    }.merge(@params))
  end
end

class PaymentRequest
  include Mongoid::Document

  field :status, :type => Symbol, :default => :pending # Valid statuses: :completed, :pending, :failed
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

  scope :completed, where(:status => :completed)
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


  def self.send_payments(group)
    err = []
    while group.count > 250
      err += self.send_payments(group.take 250)
      group = group.drop 250
    end

    res = PaypalRequest.new(:mass_pay, {
      :currencycode => (Rails.env == :production ? 'BRL' : 'USD'),
      :receivertype => :email_address,
      :payments => group.map {|pr| {:email => pr.payment_account.to_s, :amt => pr.total.to_s}}
    }).perform

    if res['ACK'].to_s =~ /^Success/
      group.each do |pr|
        pr.status = :completed
        pr.completed_at = Date.today
        pr.save!
      end
    else
      err.push res['L_LONGMESSAGE_0']
      group.each do |pr|
        pr.status = :failed
        pr.save!
      end
    end
    err.compact
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
