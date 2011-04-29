class UserDailyStatistic
  include Mongoid::Document
  
  field :date, :type => Date
  field :downloads, :type => Integer
  field :referred_downloads, :type => Integer
  field :revenue, :type => Float
  field :referred_revenue, :type => Float
  field :updated_at, :type => Time
    
  embedded_in :user, :inverse_of => :daily_statistics

  def self.generate_statistics_for_user! user
    (1.month.ago.beginning_of_month.to_date..Date.today).each do |date|
      self.find_or_create_by(:date => date, :user => user)
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
      g.series(:name => "Downloads", :data=> daily_statistics.collect { |ds| {:name => ds.date.strftime(I18n.t("date.formats.long")), :y => ds.downloads} })
      g.xAxis(:categories => daily_statistics.collect(&:date).collect { |d| I18n.t("date.abbr_day_names")[d.wday] })
      g.yAxis(:title => {:text => "Downloads", :style => {:color => "#82BACE"}}, :allowDecimals => false)
      g.title nil
    end
  end
  
  def self.graph(start_date = nil, end_date = nil)
    start_date ||= 1.month.ago
    end_date ||= Date.today    
          
    daily_statistics = self.where(:date.gte => start_date.to_date).where(:date.lte => end_date.to_date).order_by(:date.desc)
    graph = LazyHighCharts::HighChart.new(:graph) do |g|
      g.chart(:width => 650, :height => 200, :spacingLeft => -280, :zoomType => :x)
      g.series(:name => "Downloads", :data=> daily_statistics.collect { |ds| {:name => ds.date.strftime(I18n.t("date.formats.long")), :y => ds.downloads} })
      g.xAxis(:categories => daily_statistics.collect(&:date).collect { |d| d.strftime("%d/%m/%Y") })
      g.yAxis(:title => {:text => "Downloads"}, :allowDecimals => false)
      g.title nil
    end
  end
  
  def self.method_missing(method_sym, *arguments, &block)
      # the first argument is a Symbol, so you need to_s it if you want to pattern match
      if method_sym.to_s =~ /^today_(.*)$/
        self.where(:date => Date.today).sum($1.to_sym)
      elsif method_sym.to_s =~ /^yesterday_(.*)$/
        self.where(:date => Date.yesterday).sum($1.to_sym)
      elsif method_sym.to_s =~ /^this_month_(.*)$/
        self.where(:date.gte => Time.now.beginning_of_month.to_date).where(:date.lte => Time.now.end_of_month.to_date).sum($1.to_sym)
      elsif method_sym.to_s =~ /^last_month_(.*)$/
        self.where(:date.lte => 1.month.ago.end_of_month.to_date).sum($1.to_sym) # TODO improve this
      else
        super
      end
  end
  
  def generate_statistics!
    self.downloads = user.file_downloads.where(:downloaded_at.gte => date.to_time.utc.beginning_of_day).where(:downloaded_at.lte => date.to_time.utc.end_of_day).count
    self.referred_downloads = Download.where(:file_owner_id.in => user.referred.collect(&:_id)).where(:downloaded_at.gte => date.to_time.utc.beginning_of_day).where(:downloaded_at.lte => date.to_time.utc.end_of_day).count
    
    self.revenue = downloads * 0.0 # needs to be defined with Came
    self.referred_revenue = referred_downloads * 0.0 # needs to be defined with Came
    
    self.updated_at = Time.now.utc
    save! if changed?
  end
end
