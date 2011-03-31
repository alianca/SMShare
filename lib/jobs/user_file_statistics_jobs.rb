class UserFileStatisticsJob
  @queue = :user_file_statistics
  def self.perform
    UserFile.all.each do |file|
      file.statistics.generate_statistics!
    end
  end
end
