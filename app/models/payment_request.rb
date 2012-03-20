# -*- coding: utf-8 -*-
class PaymentRequest
  include Mongoid::Document

  # Estados
  #
  # PagSeguro
  # :pending -> :complete
  #        \
  #         > :canceled
  #
  # Paypal
  # :pending -> :waiting_user -> :complete
  #        \                \
  #         > :canceled      > :refused_by_user
  #

  field :status, :type => Symbol, :default => :pending # Valid statuses: :complete, :pending, :canceled, :waiting_user, :refused_by_user
  field :payment_method, :type => Symbol # Valid methods: :paypal, :pag_seguro
  field :payment_account, :type => String
  field :value, :type => Float
  field :referred_value, :type => Float
  field :completed_at, :type => Date
  field :requested_at, :type => Date
  field :request_month, :type => Date

  before_validation :set_request_month
  validates_uniqueness_of :request_month, :scope => [:user_id]

  belongs_to_related :user

  scope :completed, where(:status => :complete)
  scope :pending, where(:status.in => [:pending, :waiting_user])
  scope :canceled, where(:status.in => [:canceled, :refused_by_user])

  def value
    self.status == :pending ? user.statistics.revenue_available_for_payment : self[:value]
  end

  def referred_value
    self.status == :pending ? user.statistics.referred_revenue_available_for_payment : self[:referred_value]
  end

  def total
    value + referred_value
  end

  def request_month
    I18n.translate("date.month_names")[self[:request_month].month]
  end

  def self.graph
    graph = LazyHighCharts::HighChart.new(:graph) do |g|
      payment_requests = self.order_by(:request_month.asc).limit(12)
      g.chart(:width => 635, :height => 200, :spacingLeft => -240, :zoomType => :x)
      g.series(:name => "Valor", :type => :area, :data=> payment_requests.collect { |pr| {:name => "Valor requisitado", :y => pr.total} })
      g.xAxis(:categories => payment_requests.collect(&:request_month))
      g.yAxis(:title => {:text => "Valor"})
      g.title nil
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
