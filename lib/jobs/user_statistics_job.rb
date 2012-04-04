class Jobs::UserStatisticsJob
  @queue = :statistics

  def self.perform
    User.all.each do |user|
      user.statistics.generate_statistics!
      user.daily_statistics.each { |ds| ds.generate_statistics! }
      #UserDailyStatistic.generate_statistics_for_user! user
    end
  end
end
