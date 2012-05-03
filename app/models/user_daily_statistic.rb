# -*- coding: utf-8 -*-

class UserDailyStatistic < Statistic
  include Mongoid::Document

  field :date, :type => Date
  field :downloads, :type => Integer
  field :referred_downloads, :type => Integer
  field :revenue, :type => Float
  field :referred_revenue, :type => Float
  field :updated_at, :type => Time

  embedded_in :user, :inverse_of => :daily_statistics

  def self.generate_statistics_for_user! user
    user.daily_statistics.destroy_all
    (1.month.ago.beginning_of_month.to_date..Date.today).each do |date|
      user.daily_statistics.find_or_create_by(:date => date)
    end
    user.daily_statistics.collect(&:generate_statistics!)
  end

  def self.cleanup_old_statistics_for_user! user
    user.daily_statistics.where(:date.lt => 1.month.ago.beginning_of_month).destroy_all
  end

  def self.last_7_days_graph
    daily_statistics = self.order_by(:date.desc).limit(7).reverse
    graph = LazyHighCharts::HighChart.new(:graph) do |g|
      g.chart(:width => 280, :height => 150, :spacingLeft => -278)
      g.colors(["#82BACE"])
      g.series(:name => "Downloads", :data=> daily_statistics.collect { |ds|
                 {:name => I18n.l(ds.date, :format => I18n.t("date.formats.long")), :y => ds.downloads} })
      g.xAxis(:categories => daily_statistics.collect(&:date).collect { |d| I18n.t("date.abbr_day_names")[d.wday] })
      g.yAxis(:title => {:text => "Downloads", :style => {:color => "#82BACE"}}, :allowDecimals => false)
      g.title nil
    end
  end

  def self.graph(start_date_or_collection = nil, end_date = nil)
    if start_date_or_collection.instance_of? Mongoid::Criteria
      daily_statistics = start_date_or_collection
    else
      start_date = start_date || 1.month.ago
      end_date ||= Date.today

      daily_statistics = self.where(:date.gte => start_date.to_date).where(:date.lte => end_date.to_date).order_by(:date.desc)
    end

    dates_array = daily_statistics.collect(&:date).collect { |d| d.strftime("%d/%m") }

    data = daily_statistics.collect do |ds|
      name = I18n.l(ds.date, :format => I18n.t("date.formats.long"))
      {
        :download => { :name => name, :y => ds.downloads },
        :referred => { :name => name, :y => ds.referred_downloads }
      }
    end

    graph = LazyHighCharts::HighChart.new(:graph) do |g|
      g.chart(:width => 635, :height => 200, :spacingLeft => -280, :zoomType => :x)
      g.series(:name => "Downloads", :data => data.collect{ |d| d[:download] })
      g.series(:name => "2º Nivel", :data => data.collect{ |d| d[:referred] })
      g.xAxis(:categories => dates_array, :labels => { :step => (dates_array.length/8.0).ceil })
      g.yAxis(:title => {:text => "Downloads"}, :allowDecimals => false)
      g.title nil
    end
  end

  def self.method_missing(method_sym, *arguments, &block)
    user = arguments[0]
    case method_sym.to_s
    when /^today_(.*)_for$/
      user.daily_statistics.where(:date => Date.today).collect(&$1.to_sym).sum
    when /^yesterday_(.*)_for$/
      user.daily_statistics.where(:date => Date.yesterday).collect(&$1.to_sym).sum
    when /^this_month_(.*)_for$/
      user.daily_statistics.where(:date.gte => Time.now.beginning_of_month.to_date).
        where(:date.lte => Time.now.end_of_month.to_date).collect(&$1.to_sym).sum
    when /^last_month_(.*)_for$/
      user.daily_statistics.where(:date.lte => 1.month.ago.end_of_month.to_date).collect(&$1.to_sym).sum
    else
      super
    end
  end

  def generate_statistics!
    self.downloads = user.downloads_for date
    self.referred_downloads = user.referred.collect{|r| r.downloads_for date}.sum
    self.revenue = downloads * TOTAL_VALUE
    self.referred_revenue = referred_downloads * REFERRED_VALUE

    self.updated_at = Time.now.utc
    save! if changed?
  end
end
