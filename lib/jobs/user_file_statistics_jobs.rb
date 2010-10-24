class UserFileStatisticsJob
  def perform
    UserFile.all.each do |file|
      file.statistics.generate_statistics!
    end
  end
end