class Jobs::UserFileStatisticsJob
  @queue = :statistics

  def self.perform file_id
    UserFile.find(file_id).statistics.generate_statistics!
  end
end
