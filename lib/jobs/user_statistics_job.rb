class Jobs::UserStatisticsJob
  @queue = :statistics

  def self.perform user_id
    User.find(BSON::ObjectId(user_id)).build_statistics
  end
end
