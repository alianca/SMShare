class UserStatisticsJob
  @queue = :user_statistics
  def self.perform(id)
    puts id.to_s
    User.all.each do |user|
      user.statistics.generate_statistics!
      UserDailyStatistic.generate_statistics_for_user! user
    end
  end
end
