class Jobs::UserStatisticsJob
  @queue = :statistics

  def self.perform
    User.all.each do |user|
      UserDailyStatistic.generate_statistics_for_user! user
      user.statistics.generate_statistics!
    end
  end
end
